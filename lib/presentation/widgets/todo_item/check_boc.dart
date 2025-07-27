import 'package:flutter/material.dart';
import 'package:tudu/core/theme/app_theme.dart';

class TodoCheckbox extends StatelessWidget {
  final bool isCompleted;
  final VoidCallback onTap;

  const TodoCheckbox({
    super.key,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCompleted ? const Color(0xFF1E6F9F) : AppTheme.transparent,
          border: Border.all(
            color: isCompleted
                ? const Color(0xFF1E6F9F)
                : AppTheme.white.withOpacity(0.4),
            width: 2,
          ),
          boxShadow: isCompleted
              ? [
                  BoxShadow(
                    color: const Color(0xFF1E6F9F).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: isCompleted
            ?  Icon(
                Icons.check_rounded,
                color: AppTheme.white,
                size: 18,
              )
            : null,
      ),
    );
  }
}