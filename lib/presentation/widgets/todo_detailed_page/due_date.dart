import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tudu/presentation/bloc/edit_todo/edit_todo_cubit.dart';
import 'package:tudu/presentation/widgets/add_todo/date_picker_container.dart';

class DueDateSection extends StatelessWidget {
  final DateTime? dueDate;
  final TimeOfDay? time;
  final bool isCompleted;

  const DueDateSection({
    super.key,
    required this.dueDate,
    required this.time,
    required this.isCompleted,
  });

  void _onDateTimeChanged(BuildContext context, DateTime? date, TimeOfDay? time) {
    log('DueDateSection: onDateTimeChanged called with date=$date, time=$time');
    context.read<EditTodoCubit>().updateDueDateAndTime(date, time);
  }

  @override
  Widget build(BuildContext context) {
    return DateTimePickerContainer(
      dueDate: dueDate,
      time: time,
      isCompleted: isCompleted,
      onDateTimeChanged: (date, time) => _onDateTimeChanged(context, date, time),
    );
  }
}