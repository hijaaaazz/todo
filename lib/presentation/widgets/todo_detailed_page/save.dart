import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  final bool isValid;
  final VoidCallback onPressed;

  const SaveButton({super.key, required this.isValid, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isValid
              ? [
                  const Color(0xFF1E6F9F),
                  const Color(0xFF1E6F9F).withOpacity(0.8),
                ]
              : [
                  Colors.grey.withOpacity(0.3),
                  Colors.grey.withOpacity(0.2),
                ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isValid
                ? const Color(0xFF1E6F9F).withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.check, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}