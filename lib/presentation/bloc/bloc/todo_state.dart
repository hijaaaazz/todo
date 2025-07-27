import 'package:tudu/data/models/tab_item.dart';
import 'package:tudu/domain/enities/todo_entity.dart';

abstract class TodoState {
  const TodoState();
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoError extends TodoState {
  final String message;
  const TodoError(this.message);
}

class TodoLoaded extends TodoState {
  final List<TodoEntity> allTodos;
  final TabItem selectedTab;
  final String searchQuery;
  final Map<String, List<TodoEntity>> displayTodosByDueDate;
  final int totalTasks;
  final int completedTasks;
  final int pendingTasks;

  const TodoLoaded({
    required this.allTodos,
    this.selectedTab = TabItem.total,
    this.searchQuery = '',
    required this.displayTodosByDueDate,
    required this.totalTasks,
    required this.completedTasks,
    required this.pendingTasks,
  });

  // Computed properties
  List<TodoEntity> get displayTodos {
    List<TodoEntity> filteredTodos = _getFilteredTodosByTab();
    
    if (searchQuery.isNotEmpty) {
      filteredTodos = filteredTodos.where((todo) {
        return todo.text.toLowerCase().contains(searchQuery.toLowerCase()) ||
            (todo.description?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);
      }).toList();
    }
    
    return filteredTodos;
  }

  List<TodoEntity> _getFilteredTodosByTab() {
    switch (selectedTab) {
      case 'Active':
        return allTodos.where((todo) => !todo.isCompleted).toList();
      case 'Completed':
        return allTodos.where((todo) => todo.isCompleted).toList();
      case 'Total':
      default:
        return allTodos;
    }
  }

  // Group todos by due date for display
  static Map<String, List<TodoEntity>> _groupTodosByDate(List<TodoEntity> todos) {
    final Map<String, List<TodoEntity>> grouped = {
      'Today': [],
      'Tomorrow': [],
      'This Week': [],
      'Later': [],
    };

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final endOfWeek = today.add(Duration(days: 7 - today.weekday));

    for (final todo in todos) {
      if (todo.dueDate == null) {
        grouped['Later']!.add(todo);
        continue;
      }

      final dueDate = DateTime(
        todo.dueDate!.year,
        todo.dueDate!.month,
        todo.dueDate!.day,
      );

      if (dueDate == today) {
        grouped['Today']!.add(todo);
      } else if (dueDate == tomorrow) {
        grouped['Tomorrow']!.add(todo);
      } else if (dueDate.isAfter(tomorrow) && dueDate.isBefore(endOfWeek.add(const Duration(days: 1)))) {
        grouped['This Week']!.add(todo);
      } else {
        grouped['Later']!.add(todo);
      }
    }

    return grouped;
  }

  TodoLoaded copyWith({
    List<TodoEntity>? allTodos,
    TabItem? selectedTab,
    String? searchQuery,
  }) {
    final newAllTodos = allTodos ?? this.allTodos;
    final newSelectedTab = selectedTab ?? this.selectedTab;
    final newSearchQuery = searchQuery ?? this.searchQuery;

    // Create filtered todos based on tab selection and search
    List<TodoEntity> filteredTodos = _getFilteredTodosByTabStatic(newAllTodos, newSelectedTab);
    
    if (newSearchQuery.isNotEmpty) {
      filteredTodos = filteredTodos.where((todo) {
        return todo.text.toLowerCase().contains(newSearchQuery.toLowerCase()) ||
            (todo.description?.toLowerCase().contains(newSearchQuery.toLowerCase()) ?? false);
      }).toList();
    }

    return TodoLoaded(
      allTodos: newAllTodos,
      selectedTab: newSelectedTab,
      searchQuery: newSearchQuery,
      displayTodosByDueDate: _groupTodosByDate(filteredTodos),
      totalTasks: newAllTodos.length,
      completedTasks: newAllTodos.where((todo) => todo.isCompleted).length,
      pendingTasks: newAllTodos.where((todo) => !todo.isCompleted).length,
    );
  }

  static List<TodoEntity> _getFilteredTodosByTabStatic(List<TodoEntity> todos, TabItem tab) {
    switch (tab) {
      case TabItem.active:
        return todos.where((todo) => !todo.isCompleted).toList();
      case TabItem.completed:
        return todos.where((todo) => todo.isCompleted).toList();
      case TabItem.total:
      return todos;
    }
  }

  // Factory constructor for initial load
  factory TodoLoaded.initial(List<TodoEntity> todos) {
    return TodoLoaded(
      allTodos: todos,
      selectedTab: TabItem.total,
      searchQuery: '',
      displayTodosByDueDate: _groupTodosByDate(todos),
      totalTasks: todos.length,
      completedTasks: todos.where((todo) => todo.isCompleted).length,
      pendingTasks: todos.where((todo) => !todo.isCompleted).length,
    );
  }
}