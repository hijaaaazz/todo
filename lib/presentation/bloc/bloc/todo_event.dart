import 'package:tudu/data/models/tab_item.dart';

abstract class TodoEvent {
  const TodoEvent();

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

}

class UpdateTodo extends TodoEvent {
  final String id;
  final String? text;
  final String? description;
  final DateTime? dueDate;
  final String userId;

  const UpdateTodo({required this.id,required this.userId,this.text, this.description, this.dueDate});

}

class ToggleTodo extends TodoEvent {
  final String id;
  final String userId;
  final bool status;

  const ToggleTodo({required this.id,required this.userId,required this.status});

}

class DeleteTodo extends TodoEvent {
  final String id;
  final String userId;

  const DeleteTodo({required this.id,required this.userId});

}

class SearchTodos extends TodoEvent {
  final String query;

  const SearchTodos(this.query);

}

class SearchByDate extends TodoEvent {
  final DateTime date;

  const SearchByDate(this.date);

}

class ClearDateFilter extends TodoEvent {}

class SelectTab extends TodoEvent {
  final TabItem tab;

  const SelectTab(this.tab);

}