abstract class TodoEvent {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

class LoadTodos extends TodoEvent {
  final String userId;
  LoadTodos({required this.userId});
}

class AddTodoEvent extends TodoEvent {
  final String text;
  final String? description;
  final DateTime? dueDate;
  final String? userId;

  const AddTodoEvent({
    required this.text,
    this.description,
    this.dueDate,
    this.userId,
  });

  @override
  List<Object?> get props => [text, description, dueDate, userId];
}

class UpdateTodo extends TodoEvent {
  final String id;
  final String text;
  final String? description;
  final DateTime? dueDate;

  const UpdateTodo(this.id, this.text, {this.description, this.dueDate});

  @override
  List<Object?> get props => [id, text, description, dueDate];
}

class ToggleTodo extends TodoEvent {
  final String id;

  const ToggleTodo(this.id);

  @override
  List<Object> get props => [id];
}

class DeleteTodo extends TodoEvent {
  final String id;

  const DeleteTodo(this.id);

  @override
  List<Object> get props => [id];
}

class SearchTodos extends TodoEvent {
  final String query;

  const SearchTodos(this.query);

  @override
  List<Object> get props => [query];
}

class SearchByDate extends TodoEvent {
  final DateTime date;

  const SearchByDate(this.date);

  @override
  List<Object> get props => [date];
}

class ClearDateFilter extends TodoEvent {}

class SelectTab extends TodoEvent {
  final String tab;

  const SelectTab(this.tab);

  @override
  List<Object> get props => [tab];
}