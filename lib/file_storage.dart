import 'dart:convert';
import 'dart:io';
import 'task.dart';
import 'exceptions.dart';

class FileStorage {
final File _file;

// Le constructeur prend le chemin du fichier (ex: 'tasks.json')
FileStorage(String filePath) : _file = File(filePath);

// 1. SAUVEGARDER LES TÂCHES
Future<void> saveTasks(List<Task> tasks) async {
try {
// On convertit chaque tâche en Map JSON grâce à votre méthode .toJson()
final List<Map<String, dynamic>> jsonList = tasks.map((task) => task.toJson()).toList();

// On encode la liste en chaîne de caractères lisible (avec indentations pour que ce soit propre)
final String jsonString = const JsonEncoder.withIndent('  ').convert(jsonList);

// On écrit le texte dans le fichier de manière asynchrone
await _file.writeAsString(jsonString);
} catch (e) {
throw StorageException("Failed to write to file : $e");
}
}

// 2. CHARGER LES TÂCHES
Future<List<Task>> loadTasks() async {
try {
// Si le fichier n'existe pas encore (premier lancement), on retourne une liste vide
if (!await _file.exists()) {
return [];
}

// On lit le contenu du fichier
final String jsonString = await _file.readAsString();

// Si le fichier est vide, on retourne une liste vide
if (jsonString.trim().isEmpty) {
return [];
}

// On décode la chaîne JSON en liste dynamique
final List<dynamic> jsonList = jsonDecode(jsonString);

// On reconstruit chaque tâche grâce à votre constructeur d'usine Task.fromJson(json)
return jsonList.map((jsonItem) => Task.fromJson(jsonItem as Map<String, dynamic>)).toList();
} catch (e) {
throw StorageException("Data file is corrupt or inaccessible : $e");}}
}