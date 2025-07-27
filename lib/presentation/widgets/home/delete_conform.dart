// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tudu/core/theme/app_theme.dart';

class DeleteConfirmationSection extends StatelessWidget {
  const DeleteConfirmationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.red.withOpacity(0.2),
                AppTheme.red.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child:  Icon(
            Icons.delete_outline_rounded,
            color: AppTheme.red,
            size: 40,
          ),
        ),
        const SizedBox(height: 24),
         Text(
          'Delete Task',
          style: TextStyle(
            color: AppTheme.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Are you sure you want to delete this task? This action cannot be undone.',
          style: TextStyle(
            color: AppTheme.white.withOpacity(0.7),
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}