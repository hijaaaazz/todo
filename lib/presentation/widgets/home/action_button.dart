// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tudu/core/theme/app_theme.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const FloatingActionButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.highlight,
            AppTheme.highlight.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.highlight.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: AppTheme.transparent,
        elevation: 0,
        icon:  Icon(
          Icons.add_rounded,
          color: AppTheme.white,
          size: 24,
        ),
        label:  Text(
          'Add Task',
          style: TextStyle(
            color: AppTheme.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}