// ignore_for_file: unused_field

import 'package:flutter/material.dart';

class AppTheme {
  static ThemeMode currentThemeMode = ThemeMode.light;

  static void setThemeMode(ThemeMode mode) {
    currentThemeMode = mode;
  }

  // Base Colors (unchanged directly, used internally)
  static const Color _white = Colors.white;
  static const Color _black = Colors.black;
  static const Color _red = Colors.red;
  static const Color _orange = Colors.deepOrange;
  static const Color _yellow = Colors.amber;
  static const Color _transparent = Colors.transparent;
  static const Color _grey = Colors.grey;
  static const Color _redAccent = Colors.redAccent;
  static const Color _orangeAccent = Colors.orangeAccent;
  static const Color _amber = Colors.amber;

  // Public Getters - adapt to current theme
  static Color get white => Colors.white ;
  static Color get black => Colors.black ;
  static Color get red => _red;
  static Color get orange => _orange;
  static Color get yellow => _yellow;
  static Color get grey =>  Colors.grey.shade300 ;
  static Color get redAccent => _redAccent;
  static Color get orangeAccent => _orangeAccent;
  static Color get amber => _amber;
  static Color get transparent => _transparent;
  static Color get highlight => const Color(0xFF1E6F9F);
  // Static Backgrounds
  static const Color background = Color(0xFF1A1A1A);

  // Todo-related colors with opacity
  static _TodoColors get todoColors => _TodoColors();

  // DARK THEME
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: highlight,
      colorScheme: ColorScheme.dark(
        primary: highlight,
        secondary: highlight,
        background: background,
        error: red,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: white),
        bodyMedium: TextStyle(color: white),
        bodySmall: TextStyle(color: white),
        headlineSmall: TextStyle(color: white),
        titleMedium: TextStyle(color: white),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: highlight,
          foregroundColor: white,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: highlight,
        ),
      ),
    );
  }

}

// 🔽 Theme-aware Todo Colors
class _TodoColors {
  Color get normal => AppTheme.white.withOpacity(0.6);
  Color get dueSoon => AppTheme.yellow.withOpacity(0.8);
  Color get dueToday => AppTheme.orange.withOpacity(0.8);
  Color get overdue => AppTheme.red.withOpacity(0.8);

  // Extra (optional)
  Color get lowPriority => AppTheme.black.withOpacity(0.1);
  Color get mediumPriority => AppTheme.grey.withOpacity(0.2);
  Color get muted => AppTheme.grey.withOpacity(0.3);
  Color get urgentAccent => AppTheme.redAccent;
  Color get warningAccent => AppTheme.orangeAccent;
  Color get infoAccent => AppTheme.amber;
}
