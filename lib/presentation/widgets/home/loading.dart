// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tudu/core/theme/app_theme.dart';

class TodoLoadingWidget extends StatelessWidget {
  const TodoLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.highlight.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child:  Center(
              child: CircularProgressIndicator(
                color: AppTheme.highlight,
                strokeWidth: 2.5,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Loading your tasks...',
            style: TextStyle(
              color: AppTheme.white.withOpacity(0.7),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}