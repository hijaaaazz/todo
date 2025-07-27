import 'package:flutter/material.dart';
import 'package:tudu/presentation/bloc/bloc/todo_state.dart';

enum TabItem {
  total(
    label: 'Total',
    icon: Icons.task_alt_rounded,
  ),
  active(
    label: 'Active',
    icon: Icons.radio_button_unchecked_rounded,
  ),
  completed(
    label: 'Completed',
    icon: Icons.check_circle_outline_rounded,
  );

  final String label;
  final IconData icon;

  const TabItem({
    required this.label,
    required this.icon,
  });

  String getValue(TodoLoaded state) {
    switch (this) {
      case TabItem.total:
        return state.totalTasks.toString();
      case TabItem.active:
        return state.pendingTasks.toString();
      case TabItem.completed:
        return state.completedTasks.toString();
    }
  }
}