// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final String cancelText;
  final String actionText;
  final Color actionColor;
  final VoidCallback? onCancel;
  final VoidCallback? onAction;
  final bool isActionEnabled;

  const ActionButtons({
    super.key,
    this.cancelText = 'Cancel',
    this.actionText = 'Action',
    this.actionColor = const Color(0xFF1E6F9F),
    this.onCancel,
    this.onAction,
    this.isActionEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
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
                color: Colors.white.withOpacity(0.7),
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
                  isActionEnabled ? actionColor : Colors.grey.withOpacity(0.3),
                  isActionEnabled
                      ? actionColor.withOpacity(0.8)
                      : Colors.grey.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: isActionEnabled
                      ? actionColor.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: isActionEnabled ? onAction : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                actionText,
                style: const TextStyle(
                  color: Colors.white,
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