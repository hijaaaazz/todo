import 'package:flutter/material.dart';
import 'package:tudu/core/theme/app_theme.dart';

class TodoItemContainer extends StatelessWidget {
  final bool isCompleted;
  final VoidCallback onTap;
  final Widget child;

  const TodoItemContainer({
    super.key,
    required this.isCompleted,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppTheme.transparent,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.white.withOpacity(isCompleted ? 0.06 : 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isCompleted
                ? const Color(0xFF1E6F9F).withOpacity(0.3)
                : AppTheme.white.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}