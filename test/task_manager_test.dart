import 'package:test/test.dart';
import 'package:dart_c_l_i/models/task.dart';
import 'package:dart_c_l_i/data_access/repository.dart';
import 'package:dart_c_l_i/data_access/file_storage.dart';
import 'package:dart_c_l_i/exceptions/exceptions.dart';

void main() {
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
      final lowTask = StandardTask(
        id: 'low',
        title: 'Low',
        priority: Priority.low,
      );
      final highTask = UrgentTask(
        id: 'high',
        title: 'High',
        internalCode: '01',
      );
      repo.add(lowTask);
      repo.add(highTask);

      final sorted = repo.getAllSortedByPriority();
      expect(sorted.first.id, equals('high'));
    });

    // NOUVEAU TEST : Vérifie la levée de l'exception personnalisée de recherche
    test('getById must throw ItemNotFoundException when ID is missing', () {
      expect(
        () => repo.getById('non_existent_id'),
        throwsA(isA<ItemNotFoundException>()),
      );
    });

    // ✅ NOUVEAU TEST : Vérifie la levée de l'exception personnalisée de suppression
    test('Deleting a non-existent task must throw ItemNotFoundException', () {
      expect(
        () => repo.delete('invalid_id'),
        throwsA(isA<ItemNotFoundException>()),
      );
    });

    //  NOUVEAU TEST : Vérifie la levée de l'exception personnalisée de stockage (dossier inaccessible)
    test(
      'FileStorage must throw StorageException under invalid pathways',
      () async {
        final invalidStorage = FileStorage('///////tasks.json');
        expect(
          () => invalidStorage.saveTasks([]),
          throwsA(isA<StorageException>()),
        );
      },
    );
  });
}
