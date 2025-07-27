import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatelessWidget {
  final bool isCompleted;
  final String label;
  final String hintText;
  final DateTime? initialDate;
  final TimeOfDay? initialTime;
  final Function(DateTime?, TimeOfDay?)? onDateTimeChanged;

  const DateTimePicker({
    super.key,
    this.label = 'Due Date (Optional)',
    this.hintText = 'Set due date',
    this.initialDate,
    this.initialTime,
    this.onDateTimeChanged,
    this.isCompleted = false
  });

  Future<void> _selectDateTime(BuildContext context) async {
    final now = DateTime.now();
    log('DateTimePicker: Opening date picker');

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: now, // Start from today, no past dates allowed
      lastDate: now.add(const Duration(days: 365 * 5)),
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

    if (pickedDate == null) {
      log('DateTimePicker: Date picker cancelled');
      return;
    }

    log('DateTimePicker: Date selected: $pickedDate');
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

    if (pickedTime == null) {
      log('DateTimePicker: Time picker cancelled');
      return;
    }

    final combinedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    // Check if selected time is in the past (for today's date)
    if (combinedDateTime.isBefore(now)) {
      log('DateTimePicker: Selected time is in the past → Ignored');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot set time in the past')),
        );
      }
      return;
    }

    onDateTimeChanged?.call(pickedDate, pickedTime);
  }

  String _formatDateTime(DateTime? date, TimeOfDay? time, BuildContext context) {
    if (date == null) return hintText;

    final now = DateTime.now();
    final selected = DateTime(date.year, date.month, date.day);
    final difference = selected.difference(DateTime(now.year, now.month, now.day)).inDays;

    String label;
    if (difference < 0) {
      label = 'Overdue';
    } else if (difference == 0) {
      label = 'Today';
    } else if (difference == 1) {
      label = 'Tomorrow';
    } else {
      label = DateFormat('d MMM').format(date);
    }

    if (time != null) {
      final timeFormatted = time.format(context);
      return '$label at $timeFormatted';
    }

    return label;
  }

  Color _getTextColor(DateTime? date) {
    if (date == null) return Colors.white.withOpacity(0.5);

    final now = DateTime.now();
    final selected = DateTime(date.year, date.month, date.day);
    final diff = selected.difference(DateTime(now.year, now.month, now.day)).inDays;

    if (diff < 0) return Colors.redAccent;
    if (diff == 0) return Colors.orangeAccent;
    if (diff <= 3) return Colors.amber;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
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
          onTap: () {
            if(isCompleted){
              return;
            }
            _selectDateTime(context);
          },
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
                      colors: [
                        const Color(0xFF1E6F9F),
                        const Color(0xFF1E6F9F).withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.schedule_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _formatDateTime(initialDate, initialTime, context),
                    style: TextStyle(
                      color: _getTextColor(initialDate),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (initialDate != null)
                  GestureDetector(
                    onTap: () => onDateTimeChanged?.call(null, null),
                    child: Icon(Icons.close_rounded, color: Colors.white.withOpacity(0.5), size: 20),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Example usage
class DateTimePickerExample extends StatefulWidget {
  const DateTimePickerExample({super.key});

  @override
  State<DateTimePickerExample> createState() => _DateTimePickerExampleState();
}

class _DateTimePickerExampleState extends State<DateTimePickerExample> {
  DateTime? initialDate;
  TimeOfDay? initialTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DateTime Picker Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DateTimePicker(
              label: 'Task Due Date',
              hintText: 'Select due date and time',
              initialDate: initialDate,
              initialTime: initialTime,
              onDateTimeChanged: (date, time) {
                setState(() {
                  initialDate = date;
                  initialTime = time;
                });
              },
            ),
            const SizedBox(height: 20),
            if (initialDate != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected:',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Text('Date: ${DateFormat('yyyy-MM-dd').format(initialDate!)}'),
                      if (initialTime != null)
                        Text('Time: ${initialTime!.format(context)}'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}