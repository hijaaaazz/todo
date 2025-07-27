import 'package:flutter/material.dart';
import 'package:tudu/core/theme/app_theme.dart';
import 'package:tudu/presentation/widgets/todo_item/date_display.dart';

class TodoTaskContent extends StatelessWidget {
  final String text;
  final DateTime? dueDate;
  final bool isCompleted;

  const TodoTaskContent({
    super.key,
    required this.text,
    required this.dueDate,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            color: isCompleted ? AppTheme.white.withOpacity(0.5) : AppTheme.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            decorationColor: AppTheme.white.withOpacity(0.5),
            decorationThickness: 2,
          ),
        ),
        if (dueDate != null) ...[
          const SizedBox(height: 8),
          DateDisplay(date: dueDate!, isCompleted: isCompleted),
        ],
      ],
    );
  }
}