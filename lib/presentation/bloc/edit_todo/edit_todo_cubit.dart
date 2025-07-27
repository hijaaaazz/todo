import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tudu/domain/enities/todo_entity.dart';

class EditTodoState {
  final String text;
  final String description;
  final DateTime? dueDate;
  final TimeOfDay? time;

  EditTodoState({
    required this.text,
    required this.description,
    this.dueDate,
    this.time,
  });

  EditTodoState copyWith({
    String? text,
    String? description,
    DateTime? dueDate,
    TimeOfDay? time,
  }) {
    return EditTodoState(
      text: text ?? this.text,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      time: time ?? this.time,
    );
  }
}

class EditTodoCubit extends Cubit<EditTodoState> {
  EditTodoCubit(TodoEntity todo)
      : super(EditTodoState(
          text: todo.text,
          description: todo.description ?? '',
          dueDate: todo.dueDate,
          time: todo.dueDate != null
              ? TimeOfDay.fromDateTime(todo.dueDate!)
              : null,
        ));

  void updateText(String text) {
    emit(state.copyWith(text: text));
  }

  void updateDescription(String description) {
    emit(state.copyWith(description: description));
  }

  void updateDueDateAndTime(DateTime? dueDate, TimeOfDay? time) {
    emit(state.copyWith(dueDate: dueDate, time: time));
  }
}