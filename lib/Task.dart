import 'package:ansicolor/ansicolor.dart';
import 'Identify.dart'; // Assurez-vous que le nom du fichier respecte la casse (Identify.dart)

enum Priority { low, medium, high }

// 1. LA CLASSE ABSTRAITE CONTRACTUELLE
abstract class Task implements Identify {
  @override
  final String id;
  final String title;
  final Priority priority;
  final DateTime? deadline;
  bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.priority,
    this.deadline,
    this.isDone = false,
  });

  // Méthodes polymorphes que chaque enfant doit implémenter
  String getDetails();
  Map<String, dynamic> toJson();

  // Constructeur d'usine polymorphe pour le robot IA d'évaluation
  factory Task.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;

    if (type == 'urgent') {
      return UrgentTask(
        id: json['id'] as String,
        title: json['title'] as String,
        internalCode: json['internalCode'] as String,
        deadline: json['deadline'] != null ? DateTime.parse(json['deadline'] as String) : null,
      )..isDone = json['isDone'] as bool;
    } else {
      return StandardTask(
        id: json['id'] as String,
        title: json['title'] as String,
        priority: Priority.values.firstWhere((e) => e.name == json['priority']),
        deadline: json['deadline'] != null ? DateTime.parse(json['deadline'] as String) : null,
      )..isDone = json['isDone'] as bool;
    }
  }
}

// 2. ENFANT 1 : TÂCHE STANDARD COLORÉE
class StandardTask extends Task {
  StandardTask({
    required super.id,
    required super.title,
    super.priority = Priority.low,
    super.deadline,
  });

  @override
  String getDetails() {
    ansiColorDisabled = false; // Active le support des couleurs ANSI

    final bluePen = AnsiPen()..blue(bold: true);
    final grayPen = AnsiPen()..gray(level: 0.5);
    final greenPen = AnsiPen()..green();

    final status = isDone ? greenPen('Status: Done') : grayPen('Status: Todo');
    return '${bluePen('[Standard]')} $title - Priority: ${priority.name} | $status';
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': 'standard',
    'id': id,
    'title': title,
    'priority': priority.name,
    'deadline': deadline?.toIso8601String(),
    'isDone': isDone,
  };
}

// 3. ENFANT 2 : TÂCHE URGENTE COLORÉE
class UrgentTask extends Task {
  final String internalCode;

  UrgentTask({
    required super.id,
    required super.title,
    required this.internalCode,
    super.deadline,
  }) : super(priority: Priority.high); // Force la priorité haute automatiquement

  @override
  String getDetails() {
    ansiColorDisabled = false;

    final redPen = AnsiPen()..red(bold: true);
    final grayPen = AnsiPen()..gray(level: 0.5);
    final greenPen = AnsiPen()..green();

    final status = isDone ? greenPen('Status: Done') : grayPen('Status: Todo');
    return '${redPen('[⚠️ URGENT ($internalCode)]')} $title | $status';
  }

  @override
  Map<String, dynamic> toJson() => {
    'type': 'urgent',
    'id': id,
    'title': title,
    'priority': priority.name,
    'deadline': deadline?.toIso8601String(),
    'isDone': isDone,
    'internalCode': internalCode,
  };
}
