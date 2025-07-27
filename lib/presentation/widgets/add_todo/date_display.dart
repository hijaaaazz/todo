// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tudu/core/theme/app_theme.dart';

class DateDisplay extends StatelessWidget {
  final DateTime date;

  const DateDisplay({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 20),
      child: Text(
        DateFormat('EEEE, MMMM d, y').format(date),
        style: TextStyle(
          color: AppTheme.white.withOpacity(0.5),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}