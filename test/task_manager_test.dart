import 'package:test/test.dart';
import 'package:dart_c_l_i/task.dart';
import 'package:dart_c_l_i/repository.dart';
import 'package:dart_c_l_i/repository_exception.dart';

void main() {
  group('Task Models Tests', () {
    test('An urgent task must always have high priority', () {
      final urgentTask = UrgentTask(id: '1', title: 'Fix server', internalCode: 'CRIT-01');
      expect(urgentTask.priority, equals(Priority.high));
    });

    test('Task.fromJson must instantiate correct subclass', () {
      final mockJson = {
        'type': 'standard', 'id': '2', 'title': 'Report', 'priority': 'medium', 'deadline': null, 'isDone': true,
      };
      final task = Task.fromJson(mockJson);
      expect(task, isA<StandardTask>());
      expect(task.title, equals('Report'));
    });
  });

  group('Repository Features Tests', () {
    late Repository<Task> repo;

    setUp(() {
      repo = Repository<Task>();
    });

    test('markAsDone must switch the isDone property to true', () {
      final task = StandardTask(id: 'abc', title: 'Gym');
      repo.add(task);
      repo.markAsDone('abc');
      expect(repo.getById('abc').isDone, isTrue);
    });

    test('getAllSortedByPriority must sort correctly', () {
      final lowTask = StandardTask(id: 'low', title: 'Low', priority: Priority.low);
      final highTask = UrgentTask(id: 'high', title: 'High', internalCode: '01');
      repo.add(lowTask);
      repo.add(highTask);

      final sorted = repo.getAllSortedByPriority();
      expect(sorted.first.id, equals('high'));
    });

    // NOUVEAU TEST POUR L'IA : Validation du filtre dynamique de la version Pro
    test('getFilteredTasks must return only pending tasks when pendingOnly is true', () {
      final t1 = StandardTask(id: 't1', title: 'Todo Task')..isDone = false;
      final t2 = StandardTask(id: 't2', title: 'Done Task')..isDone = true;
      repo.add(t1);
      repo.add(t2);

      final pending = repo.getFilteredTasks(pendingOnly: true);
      expect(pending.length, equals(1));
      expect(pending.first.id, equals('t1'));
    });

    test('getById must throw ItemNotFoundException when ID is missing', () {
      expect(() => repo.getById('missing'), throwsA(isA<ItemNotFoundException>()));
    });
  });
}
