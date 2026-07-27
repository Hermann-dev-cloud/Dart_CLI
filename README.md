# Dart_CLI
 
# Task Manager CLI (Dart)

A pure Dart command-line application built to demonstrate advanced object-oriented programming, generic structures, and asynchronous data persistence.

## 🚀 Features & Architecture

- **CLI Interface**: Add, list, complete, and delete tasks dynamically.
- **Advanced OOP**: Abstract class (`Task`) with inheritance for specialized subclasses (`StandardTask` & `UrgentTask`).
- **Interfaces**: Polymorphism ensured via the custom `Identify` contract.
- **Generics**: Reusable CRUD operations encapsulated inside a decoupled `Repository<T>` layer.
- **Data Persistence**: Local storage with transactional file writing to `tasks.json`.
- **Error Handling**: Custom robust exceptions (`ItemNotFoundException`, `StorageException`) preventing application crashes.

---

## 🛠️ Installation & Usage

Ensure you have the [Dart SDK](https://dart.dev) installed.

### 1. Run the application
```bash
dart run bin/main.dart
```

### 2. Run the unit test suite
```bash
dart test
```

---

## 📂 Project Architecture Overview

```text
lib/
├── identify.dart    # Abstract interface contract
├── task.dart        # Core models & JSON transformation factories
├── repository.dart  # Generic database engine & sorting extensions
├── file_storage.dart# Asynchronous JSON file manager
└── exceptions.dart  # Business domain error handling definitions
test/
└── task_manager_test.dart # 5 mandatory algorithmic unit tests
```
