// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tudu/core/theme/app_theme.dart';

class ActionButtons extends StatelessWidget {
  final String cancelText;
  final String actionText;
  final Color? actionColor;
  final VoidCallback? onCancel;
  final VoidCallback? onAction;
  final bool isActionEnabled;

  const ActionButtons({
    super.key,
    this.cancelText = 'Cancel',
    this.actionText = 'Action',
    this.actionColor,
    this.onCancel,
    this.onAction,
    this.isActionEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveActionColor = actionColor ?? AppTheme.highlight;

    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: onCancel ?? () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              cancelText,
              style: TextStyle(
                color: AppTheme.white.withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  isActionEnabled ? effectiveActionColor : AppTheme.grey.withOpacity(0.3),
                  isActionEnabled
                      ? effectiveActionColor.withOpacity(0.8)
                      : AppTheme.grey.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: isActionEnabled
                      ? effectiveActionColor.withOpacity(0.3)
                      : AppTheme.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: isActionEnabled ? onAction : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.transparent,
                shadowColor: AppTheme.transparent,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                actionText,
                style: TextStyle(
                  color: AppTheme.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
