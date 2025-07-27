import 'package:flutter/material.dart';
import 'package:tudu/core/theme/app_theme.dart';

class TodoActionButtons extends StatelessWidget {
  final VoidCallback onDelete;

  const TodoActionButtons({
    super.key,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 8),
        _buildActionButton(
          icon: Icons.delete_outline_rounded,
          onPressed: onDelete,
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    bool isDestructive = false,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppTheme.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: isDestructive
              ? AppTheme.red.withOpacity(0.8)
              : AppTheme.white.withOpacity(0.7),
          size: 18,
        ),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    );
  }
}
