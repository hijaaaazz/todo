import 'dart:developer';

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
    bool clearDate = false,
    bool clearTime = false,
  }) {
    return EditTodoState(
      text: text ?? this.text,
      description: description ?? this.description,
      dueDate: clearDate ? null : (dueDate ?? this.dueDate),
      time: clearTime ? null : (time ?? this.time),
    );
  }

  bool get isValid {
    return text.trim().isNotEmpty && dueDate != null;
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
        )) {
    log('EditTodoCubit initialized: text=${state.text}, dueDate=${state.dueDate}, time=${state.time}');
  }

  void updateText(String text) {
    emit(state.copyWith(text: text));
    log('EditTodoCubit: updated text=$text');
  }

  void updateDescription(String description) {
    emit(state.copyWith(description: description));
    log('EditTodoCubit: updated description=$description');
  }

  void updateDueDateAndTime(DateTime? dueDate, TimeOfDay? time) {
    log('EditTodoCubit: updating dueDate=$dueDate, time=$time, previous dueDate=${state.dueDate}, previous time=${state.time}, stack=${StackTrace.current}');
    if (dueDate == state.dueDate && time == state.time) {
      log('EditTodoCubit: no change in dueDate or time, skipping emit');
      return;
    }
    if (dueDate != null) {
      final now = DateTime.now();
      final newDate = DateTime(dueDate.year, dueDate.month, dueDate.day);
      final currentDate = state.dueDate != null
          ? DateTime(state.dueDate!.year, state.dueDate!.month, state.dueDate!.day)
          : now;
      if (newDate.isBefore(now) && newDate.isBefore(currentDate)) {
        log('EditTodoCubit: rejecting outdated dueDate=$dueDate');
        return;
      }
    }
    emit(state.copyWith(dueDate: dueDate, time: time));
    log('EditTodoCubit: emitted new state with dueDate=$dueDate, time=$time');
  }

  void clearDueDateAndTime() {
    log('EditTodoCubit: clearing dueDate and time');
    emit(state.copyWith(clearDate: true, clearTime: true));
  }

  void reset() {
    log('EditTodoCubit: resetting state');
    emit(EditTodoState(
      text: '',
      description: '',
      dueDate: null,
      time: null,
    ));
  }
}