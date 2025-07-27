import 'package:flutter/material.dart';
import 'package:tudu/core/theme/app_theme.dart';

class DateDisplay extends StatelessWidget {
  final DateTime date;
  final bool isCompleted;

  const DateDisplay({
    super.key,
    required this.date,
    required this.isCompleted,
  });

  Color _getDueDateColor() {
    if (isCompleted) {
      return AppTheme.white.withOpacity(0.4);
    }

    final now = DateTime.now();
    final dueDate = date;
    final difference = dueDate.difference(now).inDays;

    if (difference < 0) {
      return AppTheme.red.withOpacity(0.8); // Overdue
    } else if (difference == 0) {
      return AppTheme.orange.withOpacity(0.8); // Due today
    } else if (difference <= 3) {
      return AppTheme.yellow.withOpacity(0.8); // Due soon
    } else {
      return AppTheme.white.withOpacity(0.6); // Normal
    }
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final difference = target.difference(today).inDays;

    if (difference < 0) {
      return 'Overdue';
    } else if (difference == 0) {
      return 'Due today';
    } else if (difference == 1) {
      return 'Due tomorrow';
    } else if (difference <= 7) {
      return 'Due in $difference days';
    } else {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return 'Due ${dueDate.day} ${months[dueDate.month - 1]}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.schedule_rounded,
          size: 14,
          color: _getDueDateColor(),
        ),
        const SizedBox(width: 4),
        Text(
          _formatDueDate(date),
          style: TextStyle(
            color: _getDueDateColor(),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}