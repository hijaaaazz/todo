import 'package:tudu/domain/enities/todo_entity.dart';

class TodoByDate {
  final String title;
  final List<TodoEntity> todos;

  const TodoByDate({
    required this.title,
    required this.todos,
  });

  @override
  String toString() => 'TodoSection(title: $title, todos: ${todos.length})';
}
