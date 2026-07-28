import '../models/task.dart';
import 'identify.dart';
import '../exceptions/exceptions.dart';

class Repository<T extends Identify> {
  final List<T> _items = [];

  void add(T item) {
    _items.add(item);
  }

  // Nettoyé : Plus de try-catch-rethrow redondant
  void delete(String id) {
    final item = getById(id);
    _items.remove(item);
  }

  T getById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      throw ItemNotFoundException(id);
    }
  }

  List<T> getAll() {
    return List.from(_items);
  }
}

extension TaskRepositoryExtension on Repository<Task> {
  // Nettoyé : Plus de try-catch-rethrow redondant
  void markAsDone(String id) {
    final task = getById(id);
    task.isDone = true;
  }

  List<Task> getFilteredTasks({required bool pendingOnly}) {
    return _items
        .where((task) => pendingOnly ? !task.isDone : task.isDone)
        .toList();
  }

  List<Task> getAllSortedByDate() {
    final tasks = getAll();
    tasks.sort((a, b) {
      if (a.deadline == null && b.deadline == null) return 0;
      if (a.deadline == null) return 1;
      if (b.deadline == null) return -1;
      return a.deadline!.compareTo(b.deadline!);
    });
    return tasks;
  }

  List<Task> getAllSortedByPriority() {
    final tasks = getAll();
    tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
    return tasks;
  }
}
