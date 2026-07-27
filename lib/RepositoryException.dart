abstract class RepositoryException implements Exception {
  final String message;
  RepositoryException(this.message);

  @override
  String toString() => 'Directory Error : $message';
}

// Exception spécifique si un élément n'existe pas
class ItemNotFoundException extends RepositoryException {
  ItemNotFoundException(String id) : super("Element with ID '$id' not found ");
}

// Exception spécifique si le stockage échoue (ex: problème d'écriture fichier)
class StorageException extends RepositoryException {
  StorageException(String cause) : super("Unable to save data : $cause");
}
