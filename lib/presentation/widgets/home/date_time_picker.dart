import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatelessWidget {
  final String label;
  final String hintText;
  final DateTime? initialDate;
  final TimeOfDay? initialTime;
  final ValueChanged<DateTime?>? onDateChanged;
  final ValueChanged<TimeOfDay?>? onTimeChanged;

  const DateTimePicker({
    super.key,
    this.label = 'Due Date (Optional)',
    this.hintText = 'Set due date',
    this.initialDate,
    this.initialTime,
    this.onDateChanged,
    this.onTimeChanged,
  });

  Future<void> _selectDateTime(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF1E6F9F),
              surface: Color(0xFF1A1A1A),
              onSurface: Colors.white,
              onPrimary: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF1A1A1A),
          ),
          child: child!,
        );
      },
    );

    log('DateTimePicker: pickedDate=$pickedDate');
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: initialTime ?? const TimeOfDay(hour: 23, minute: 59),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFF1E6F9F),
                surface: Color(0xFF1A1A1A),
                onSurface: Colors.white,
                onPrimary: Colors.white,
              ),
              dialogBackgroundColor: const Color(0xFF1A1A1A),
            ),
            child: child!,
          );
        },
      );
      log('DateTimePicker: pickedTime=$pickedTime');

      onDateChanged?.call(pickedDate);
      onTimeChanged?.call(pickedTime);
    } else {
      // If date picker is cancelled, clear both date and time
      onDateChanged?.call(null);
      onTimeChanged?.call(null);
    }
  }

  String _formatDateTime(DateTime? date, TimeOfDay? time) {
    if (date == null) return hintText;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDate = DateTime(date.year, date.month, date.day);
    final difference = selectedDate.difference(today).inDays;

    String dateStr;
    if (difference < 0) {
      dateStr = 'Overdue';
    } else if (difference == 0) {
      dateStr = 'Today';
    } else if (difference == 1) {
      dateStr = 'Tomorrow';
    } else {
      dateStr = DateFormat('d MMM').format(date);
    }

    if (time != null) {
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      return '$dateStr at $hour:$minute';
    }

    return dateStr;
  }

  Color _getTextColor(DateTime? date) {
    if (date == null) {
      return Colors.white.withOpacity(0.5);
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDate = DateTime(date.year, date.month, date.day);
    final difference = selectedDate.difference(today).inDays;

    if (difference < 0) {
      return Colors.red.withOpacity(0.8); // Overdue
    } else if (difference == 0) {
      return Colors.orange.withOpacity(0.8); // Today
    } else if (difference <= 3) {
      return Colors.yellow.withOpacity(0.8); // Soon
    } else {
      return Colors.white; // Normal
    }
  }

  @override
  Widget build(BuildContext context) {
    log('DateTimePicker: initialDate=$initialDate, initialTime=$initialTime');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDateTime(context),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF1E6F9F),
                        const Color(0xFF1E6F9F).withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.schedule_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _formatDateTime(initialDate, initialTime),
                    style: TextStyle(
                      color: _getTextColor(initialDate),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (initialDate != null)
                  GestureDetector(
                    onTap: () {
                      onDateChanged?.call(null);
                      onTimeChanged?.call(null);
                    },
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white.withOpacity(0.5),
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}