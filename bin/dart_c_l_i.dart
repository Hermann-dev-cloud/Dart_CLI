import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:ansicolor/ansicolor.dart';
import 'package:dart_c_l_i/RepositoryException.dart';

// Importations calibrées avec le nom exact de ton package
import 'package:dart_c_l_i/Task.dart';
import 'package:dart_c_l_i/Repository.dart';
import 'package:dart_c_l_i/FileStorage.dart';
import 'package:dart_c_l_i/exceptions.dart' ;

void main() async {
  final taskRepo = Repository<Task>();
  final storage = FileStorage('tasks.json');
  const uuid = Uuid();
  ansiColorDisabled = false;

  // Initialisation des stylos de couleur officiels
  final greenPen = AnsiPen()..green();
  final redPen = AnsiPen()..red();
  final yellowPen = AnsiPen()..yellow(bold: true);

  print(yellowPen('=== Loading tasks from local database ==='));
  try {
    final savedTasks = await storage.loadTasks();
    for (var task in savedTasks) {
      taskRepo.add(task);
    }
    print(greenPen(' ${savedTasks.length} tasks loaded successfully!\n'));
  } catch (e) {
    print(redPen(' Warning during load: $e\n'));
  }

  bool isRunning = true;
  while (isRunning) {
    print('================ ${yellowPen('Task Manager CLI Pro')} ================');
    print('1. Add a standard task');
    print('2. Add an urgent task');
    print('3. List all tasks (sorted by Priority)');
    print('4. List all tasks (sorted by Deadline/Date)');
    print('5. List ONLY pending tasks (Todo)');
    print('6. Mark a task as done');
    print('7. Delete a task');
    print('8. Exit');
    print('==================================================');
    stdout.write('Choose an option (1-8): ');

    final choice = stdin.readLineSync()?.trim();
    print('');

    try {
      switch (choice) {
        case '1':
          await _addStandardTask(taskRepo, storage, uuid);
          break;
        case '2':
          await _addUrgentTask(taskRepo, storage, uuid);
          break;
        case '3':
          _listTasks(taskRepo.getAllSortedByPriority());
          break;
        case '4':
          _listTasks(taskRepo.getAllSortedByDate());
          break;
        case '5':
          _listTasks(taskRepo.getFilteredTasks(pendingOnly: true));
          break;
        case '6':
          await _markTaskAsDone(taskRepo, storage);
          break;
        case '7':
          await _deleteTask(taskRepo, storage);
          break;
        case '8':
          isRunning = false;
          print(greenPen('Goodbye! Thank you for using Task Manager CLI Pro.'));
          break;
        default:
          print(redPen(' Invalid choice. Please enter a number between 1 and 8.'));
      }
    } on RepositoryException catch (e) {
      print(redPen(' Application Error: ${e.message}'));
    } catch (e) {
      print(redPen(' Unexpected Error: $e'));
    }
    print('');
  }
}

Future<void> _addStandardTask(Repository<Task> repo, FileStorage storage, Uuid uuid) async {
  stdout.write('Enter task title: ');
  final title = stdin.readLineSync()?.trim() ?? '';
  if (title.isEmpty) return print(' Title cannot be empty.');

  print('Select Priority:\n1. Low\n2. Medium\n3. High');
  stdout.write('Choice (1-3, default Low): ');
  final pChoice = stdin.readLineSync()?.trim();
  var priority = Priority.low;
  if (pChoice == '2') priority = Priority.medium;
  if (pChoice == '3') priority = Priority.high;

  final deadline = _askForDeadline();
  final id = uuid.v4().substring(0, 8); // ID unique et propre généré par le package uuid

  final task = StandardTask(id: id, title: title, priority: priority, deadline: deadline);
  repo.add(task);
  await storage.saveTasks(repo.getAll());
  print(' Standard task added and saved successfully!');
}

Future<void> _addUrgentTask(Repository<Task> repo, FileStorage storage, Uuid uuid) async {
  stdout.write('Enter urgent task title: ');
  final title = stdin.readLineSync()?.trim() ?? '';
  if (title.isEmpty) return print(' Title cannot be empty.');

  stdout.write('Enter internal emergency code (e.g. CRIT-404): ');
  final code = stdin.readLineSync()?.trim() ?? 'URGENT';

  final deadline = _askForDeadline();
  final id = uuid.v4().substring(0, 8);

  final task = UrgentTask(id: id, title: title, internalCode: code, deadline: deadline);
  repo.add(task);
  await storage.saveTasks(repo.getAll());
  print(' Urgent task added and saved successfully (Priority auto-set to HIGH)!');
}

DateTime? _askForDeadline() {
  stdout.write('Enter deadline (YYYY-MM-DD) or press Enter to skip: ');
  final dateInput = stdin.readLineSync()?.trim() ?? '';
  if (dateInput.isNotEmpty) {
    try {
      return DateTime.parse(dateInput);
    } catch (_) {
      print(' Invalid date format. Task created without deadline.');
    }
  }
  return null;
}

void _listTasks(List<Task> tasks) {
  if (tasks.isEmpty) {
    print('📭 No tasks available.');
    return;
  }
  print('--- Current Task List ---');
  for (var task in tasks) {
    print('ID: ${task.id} | ${task.getDetails()}');
  }
}

Future<void> _markTaskAsDone(Repository<Task> repo, FileStorage storage) async {
  stdout.write('Enter the ID of the task to mark as done: ');
  final id = stdin.readLineSync()?.trim() ?? '';

  repo.markAsDone(id);
  await storage.saveTasks(repo.getAll());
  print(' Task $id marked as done and updated in file.');
}

Future<void> _deleteTask(Repository<Task> repo, FileStorage storage) async {
  stdout.write('Enter the ID of the task to delete: ');
  final id = stdin.readLineSync()?.trim() ?? '';

  repo.delete(id);
  await storage.saveTasks(repo.getAll());
  print(' Task $id successfully deleted.');
}
