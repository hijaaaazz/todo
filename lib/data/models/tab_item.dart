import 'package:flutter/material.dart';
import 'package:tudu/presentation/bloc/bloc/todo_state.dart';

enum TabItem {
  total,
  active,
  completed,
  overdue;

  String get label {
    switch (this) {
      case TabItem.total:
        return 'Total';
      case TabItem.active:
        return 'Active';
      case TabItem.completed:
        return 'Completed';
      case TabItem.overdue:
        return 'Overdue';
    }
  }

  IconData get icon {
    switch (this) {
      case TabItem.total:
        return Icons.list_rounded;
      case TabItem.active:
        return Icons.radio_button_unchecked_rounded;
      case TabItem.completed:
        return Icons.check_circle_outline_rounded;
      case TabItem.overdue:
        return Icons.warning_rounded;
    }
  }

  String getValue(TodoLoaded state) {
    switch (this) {
      case TabItem.total:
        return state.totalTasks.toString();
      case TabItem.active:
        return state.pendingTasks.toString();
      case TabItem.completed:
        return state.completedTasks.toString();
      case TabItem.overdue:
        return state.overdueTasks.toString();
    }
  }
}