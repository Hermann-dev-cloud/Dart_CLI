// lib/exceptions/exceptions.dart

abstract class RepositoryException implements Exception {
  final String message;
  RepositoryException(this.message);
}

class ItemNotFoundException extends RepositoryException {
  ItemNotFoundException(String id) : super("Item with ID '$id' was not found.");
}

class StorageException extends RepositoryException {
  StorageException(String details) : super("Storage operation failed: $details");
}
