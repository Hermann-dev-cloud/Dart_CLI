import 'package:test/test.dart';
import 'package:dart_c_l_i/Task.dart';
import 'package:dart_c_l_i/Repository.dart';

void main() {
  group('Task Models Tests (Inheritance & Abstraction)', () {
    test('An urgent task must always have high priority', () {
      final urgentTask = UrgentTask(
        id: '1',
        title: 'Fix production server bug',
        internalCode: 'CRIT-01',
      );

      expect(urgentTask.priority, equals(Priority.high));
    });

    test('Task.fromJson must instantiate the correct subclass from a JSON Map', () {
      final mockJson = {
        'type': 'standard',
        'id': '2',
        'title': 'Write project report',
        'priority': 'medium',
        'deadline': null,
        'isDone': true,
      };

      final task = Task.fromJson(mockJson);

      expect(task, isA<StandardTask>());
      expect(task.title, equals('Write project report'));
      expect(task.isDone, isTrue);
    });
  });

  group('Repository Features & Error Handling Tests', () {
    late Repository<Task> repo;

    setUp(() {
      repo = Repository<Task>();
    });

    test('markAsDone must switch the isDone property to true', () {
      final task = StandardTask(id: 'abc', title: 'Go to the gym');
      repo.add(task);

      repo.markAsDone('abc');

      expect(repo
          .getById('abc')
          .isDone, isTrue);
    });

    test(
        'getAllSortedByPriority must sort tasks from highest to lowest priority', () {
      final lowTask = StandardTask(
          id: 'low_id', title: 'Low Priority Task', priority: Priority.low);
      final highTask = UrgentTask(
          id: 'high_id', title: 'Urgent Task', internalCode: 'URG-01');
      final medTask = StandardTask(id: 'med_id',
          title: 'Medium Priority Task',
          priority: Priority.medium);

      repo.add(lowTask);
      repo.add(highTask);
      repo.add(medTask);

      final sortedList = repo.getAllSortedByPriority();

      expect(sortedList[0].id, equals('high_id'));
      expect(sortedList[1].id, equals('med_id'));
      expect(sortedList[2].id, equals('low_id'));
    });

    test(
        'getAllSortedByDate must sort tasks by deadline in ascending order', () {
      final now = DateTime.now();
      final farTask = StandardTask(id: 'far_id',
          title: 'In 2 days',
          deadline: now.add(Duration(days: 2)));
      final soonTask = StandardTask(id: 'soon_id',
          title: 'In 1 hour',
          deadline: now.add(Duration(hours: 1)));
      final noDateTask = StandardTask(
          id: 'nodate_id', title: 'No Deadline', deadline: null);

      repo.add(farTask);
      repo.add(soonTask);
      repo.add(noDateTask);

      final sortedList = repo.getAllSortedByDate();

      expect(sortedList[0].id, equals('soon_id'));
      expect(sortedList[1].id, equals('far_id'));
      expect(sortedList[2].id, equals('nodate_id'));
    });

  });
}