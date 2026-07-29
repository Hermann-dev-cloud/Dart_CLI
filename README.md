# Dart_CLI — Task Manager

A pure Dart command-line application built to demonstrate advanced object-oriented programming, generic structures, and asynchronous data persistence.

## 🚀 Features & Architecture

- **CLI Interface**: Add, list, complete, and delete tasks dynamically with rich ANSI terminal colors.
- **Advanced OOP**: Abstract class (`Task`) with inheritance for specialized subclasses (`StandardTask` & `UrgentTask`).
- **Interfaces**: Polymorphism ensured via the custom `Identify` contract.
- **Generics**: Reusable CRUD operations encapsulated inside a decoupled `Repository<T>` layer.
- **Data Persistence**: Local storage with transactional file writing to `tasks.json`.
- **Error Handling**: Custom robust exceptions (`ItemNotFoundException`, `StorageException`) preventing application crashes.

---

## 🛠️ Installation & Usage

Ensure you have the [Dart SDK](https://dart.dev) installed.

### 1. Install dependencies
```bash
dart pub get
```

### 2. Run the application
```bash
dart run bin/dart_c_l_i.dart
```

### 3. Run the static code analysis
```bash
dart analyze
```

### 4. Run the unit test suite
```bash
dart test
```

---

## 📂 Project Architecture Overview

```text
lib/
├── models/
│   └── task.dart          # Core models & JSON transformation factories
├── data_access/
│   ├── identify.dart      # Abstract interface contract
│   ├── repository.dart    # Generic database engine & filtering/sorting extensions
│   └── file_storage.dart  # Asynchronous JSON file manager
└── exceptions/
    └── exceptions.dart    # Unified hierarchical error handling definitions
bin/
└── dart_c_l_i.dart        # Main interactive CLI terminal entry point
test/
└── task_manager_test.dart # 5 mandatory algorithmic unit tests & exception validation
```
