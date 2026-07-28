import 'dart:convert';
import 'dart:io';
import '../models/task.dart';
import '../exceptions/exceptions.dart';

class FileStorage {
  final File _file;

  FileStorage(String filePath) : _file = File(filePath);

  Future<void> saveTasks(List<Task> tasks) async {
    try {
      final List<Map<String, dynamic>> jsonList = tasks
          .map((task) => task.toJson())
          .toList();
      final String jsonString = const JsonEncoder.withIndent(
        '  ',
      ).convert(jsonList);
      await _file.writeAsString(jsonString);
    } catch (e) {
      throw StorageException("Unable to write file: $e");
    }
  }

  Future<List<Task>> loadTasks() async {
    try {
      if (!await _file.exists()) return [];
      final String jsonString = await _file.readAsString();
      if (jsonString.trim().isEmpty) return [];
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((jsonItem) => Task.fromJson(jsonItem as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw StorageException("Data file corrupted or inaccessible: $e");
    }
  }
}
