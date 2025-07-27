import 'package:flutter/material.dart';
import 'package:tudu/presentation/widgets/add_todo/date_time_picker.dart';

class DateTimePickerContainer extends StatelessWidget {
  final DateTime? dueDate;
  final TimeOfDay? time;
  final bool isCompleted;
  final Function(DateTime?, TimeOfDay?) onDateTimeChanged;

  const DateTimePickerContainer({
    super.key,
    required this.dueDate,
    required this.time,
    required this.isCompleted,
    required this.onDateTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DateTimePicker(
      label: 'Due Date',
      hintText: 'Set due date',
      initialDate: dueDate,
      initialTime: time,
      isCompleted: isCompleted,
      onDateTimeChanged: onDateTimeChanged,
    );
  }
}