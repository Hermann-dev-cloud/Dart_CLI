import 'Task.dart';
import 'Identify.dart';
import 'RepositoryException.dart';

class Repository<T extends Identify> {
  final List<T> _items = [];

  // 1. AJOUTER UNE TÂCHE
  void add(T item) {
    _items.add(item);
  }

  // 2. SUPPRIMER UNE TÂCHE
  void delete(String id) {
    try {
      final item = getById(id);
      _items.remove(item);
    } catch (e) {
      rethrow;
    }
  }

  // RECHERCHER PAR ID
  T getById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      throw ItemNotFoundException(id);
    }
  }

  // RETOURNER TOUS LES ÉLÉMENTS BRUTS
  List<T> getAll() {
    return List.from(_items);
  }
}

// Extension spécifique pour le Repository quand il manipule des Tasks
// Cela permet de garder Repository<T> générique, tout en ajoutant des fonctionnalités pour les tâches !
extension TaskRepositoryExtension on Repository<Task> {

  // 3. MARQUER UNE TÂCHE COMME TERMINÉE
  void markAsDone(String id) {
    try {
      final task = getById(id);
      task.isDone = true;
    } catch (e) {
      rethrow;
    }
  }

  List<Task> getFilteredTasks({required bool pendingOnly}) {
    if (pendingOnly) {
      // Retourne uniquement les tâches où isDone est false
      return _items.where((task) => !task.isDone).toList();
    } else {
      // Retourne uniquement les tâches où isDone est true
      return _items.where((task) => task.isDone).toList();
    }
  }

  // 4. LISTER ET TRIER PAR DATE (Les deadlines nulles vont à la fin)
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

  // 5. LISTER ET TRIER PAR PRIORITÉ (High -> Medium -> Low)
  List<Task> getAllSortedByPriority() {
    final tasks = getAll();
    tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
    return tasks;
  }
}
