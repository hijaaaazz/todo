import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Add Todo Form State
class AddTodoFormState {
  final String title;
  final String description;
  final DateTime? dueDate;
  final TimeOfDay? time;

  const AddTodoFormState({
    this.title = '',
    this.description = '',
    this.dueDate,
    this.time,
  });

  AddTodoFormState copyWith({
    String? title,
    String? description,
    DateTime? dueDate,
    TimeOfDay? time,
    bool clearDate = false,
    bool clearTime = false,
  }) {
    return AddTodoFormState(
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: clearDate ? null : (dueDate ?? this.dueDate),
      time: clearTime ? null : (time ?? this.time),
    );
  }

  bool get isValid => title.trim().isNotEmpty;
}

// Add Todo Form Cubit
class AddTodoFormCubit extends Cubit<AddTodoFormState> {
  AddTodoFormCubit() : super(const AddTodoFormState());

  void updateTitle(String title) {
    emit(state.copyWith(title: title));
  }

  void updateDescription(String description) {
    emit(state.copyWith(description: description));
  }

  void updateDueDate(DateTime? dueDate) {
    emit(state.copyWith(dueDate: dueDate));
  }

  void updateTime(TimeOfDay? time) {
    emit(state.copyWith(time: time));
  }

  void updateDueDateAndTime(DateTime? dueDate, TimeOfDay? time) {
    emit(state.copyWith(dueDate: dueDate, time: time));
  }

  void clearDueDateAndTime() {
    emit(state.copyWith(clearDate: true, clearTime: true));
  }

  void reset() {
    emit(const AddTodoFormState());
  }
}
