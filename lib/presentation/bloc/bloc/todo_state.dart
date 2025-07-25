import 'package:tudu/domain/enities/todo_entity.dart';

abstract class TodoState {
  const TodoState();

  @override
  List<Object?> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<TodoEntity> todos;
  final String searchQuery;
  final DateTime? searchDate;
  final String selectedTab; // New field to track selected tab

  const TodoLoaded({
    required this.todos,
    this.searchQuery = '',
    this.searchDate,
    this.selectedTab = 'Total', // Default to Total
  });

  // Group todos by due date for StatsOverview
  Map<String, List<TodoEntity>> get todosByDueDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final nextWeek = today.add(const Duration(days: 7));

    final grouped = <String, List<TodoEntity>>{
      'Today': [],
      'Tomorrow': [],
      'This Week': [],
      'Later': [],
    };

    for (var todo in filteredTodos) {
      if (todo.dueDate == null) {
        grouped['Later']!.add(todo);
        continue;
      }
      final dueDate = DateTime(todo.dueDate!.year, todo.dueDate!.month, todo.dueDate!.day);
      if (dueDate.isAtSameMomentAs(today)) {
        grouped['Today']!.add(todo);
      } else if (dueDate.isAtSameMomentAs(tomorrow)) {
        grouped['Tomorrow']!.add(todo);
      } else if (dueDate.isAfter(today) && dueDate.isBefore(nextWeek)) {
        grouped['This Week']!.add(todo);
      } else {
        grouped['Later']!.add(todo);
      }
    }

    return grouped;
  }

  List<TodoEntity> get filteredTodos {
    var filtered = todos;

    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where((todo) =>
              todo.text.toLowerCase().contains(searchQuery.toLowerCase()) ||
              (todo.description?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false))
          .toList();
    }

    if (searchDate != null) {
      filtered = filtered.where((todo) {
        if (todo.dueDate == null) return false;
        final todoDate = DateTime(
          todo.dueDate!.year,
          todo.dueDate!.month,
          todo.dueDate!.day,
        );
        final filterDate = DateTime(
          searchDate!.year,
          searchDate!.month,
          searchDate!.day,
        );
        return todoDate.isAtSameMomentAs(filterDate);
      }).toList();
    }

    return filtered..sort((a, b) {
        if (a.dueDate == null && b.dueDate == null) return 0;
        if (a.dueDate == null) return 1;
        if (b.dueDate == null) return -1;
        return a.dueDate!.compareTo(b.dueDate!);
      });
  }

  List<TodoEntity> get activeTodos {
    final now = DateTime.now();
    return filteredTodos.where((todo) {
      if (todo.isCompleted) return false;
      if (todo.dueDate == null) return true;
      return todo.dueDate!.isAfter(now);
    }).toList();
  }

  List<TodoEntity> get expiredTodos {
    final now = DateTime.now();
    return filteredTodos.where((todo) {
      if (todo.isCompleted) return false;
      if (todo.dueDate == null) return false;
      return todo.dueDate!.isBefore(now);
    }).toList();
  }

  List<TodoEntity> get completedTodos =>
      filteredTodos.where((todo) => todo.isCompleted).toList();

  List<TodoEntity> get pendingTodos =>
      filteredTodos.where((todo) => !todo.isCompleted).toList();

  int get pendingCount => pendingTodos.length;
  int get completedCount => completedTodos.length;
  int get totalCount => filteredTodos.length;

  TodoLoaded copyWith({
    List<TodoEntity>? todos,
    String? searchQuery,
    DateTime? searchDate,
    bool clearSearchDate = false,
    String? selectedTab,
  }) {
    return TodoLoaded(
      todos: todos ?? this.todos,
      searchQuery: searchQuery ?? this.searchQuery,
      searchDate: clearSearchDate ? null : (searchDate ?? this.searchDate),
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }

  @override
  List<Object?> get props => [todos, searchQuery, searchDate, selectedTab];
}

class TodoError extends TodoState {
  final String message;

  const TodoError(this.message);

  @override
  List<Object> get props => [message];
}