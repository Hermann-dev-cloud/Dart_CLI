import 'Identify.dart';
enum Priority { low, medium, high }

// 1. LA CLASSE ABSTRAITE
abstract class Task implements Identify {
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
    this.isDone = false, // Par défaut, une tâche n'est pas terminée
  });

  // Méthode abstraite obligatoire : chaque enfant devra définir comment elle s'affiche
  String getDetails();

  // Méthode pour convertir l'objet en JSON pour la persistance demandée
  Map<String, dynamic> toJson();

  // Constructeur d'usine pour reconstruire les tâches depuis le JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;

    if (type == 'urgent') {
      return UrgentTask(
        id: json['id'] as String,
        title: json['title'] as String,
        internalCode: json['internalCode'] as String,
        deadline: json['deadline'] != null ? DateTime.parse(json['deadline'] as String) : null,
      )..isDone = json['isDone'] as bool; // Permet de restaurer le statut fait/non fait
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

// 2. PREMIER HÉRITIER : Tâche Standard
class StandardTask extends Task {
  StandardTask({
    required super.id,
    required super.title,
    super.priority = Priority.low,
    super.deadline,
  });

  @override
  String getDetails() => '[ Standard] $title - Priorité : ${priority.name} (Fait : $isDone)';

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

// 3. DEUXIÈME HÉRITIER : Tâche Urgente (Héritage spécifique)
class UrgentTask extends Task {
  final String internalCode; // Champ unique aux tâches urgentes

  UrgentTask({
    required super.id,
    required super.title,
    required this.internalCode,
    super.deadline,
  }) : super(priority: Priority.high); // Force automatiquement la priorité à HIGH !

  @override
  String getDetails() => '[URGENT ($internalCode)] $title - Date limite : ${deadline ?? "Immédiate"}';

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
