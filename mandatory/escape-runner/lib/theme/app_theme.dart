import 'package:flutter/material.dart';

class NeonColors {
  NeonColors._();

  static const Color background = Color(0xFF07040D);
  static const Color surface = Color(0xFF0F0A1C);
  static const Color cyan = Color(0xFF00F0FF);
  static const Color purple = Color(0xFFB026FF);
  static const Color pink = Color(0xFFFF2AA8);
  static const Color yellow = Color(0xFFFFD400);
  static const Color danger = Color(0xFFFF2A5E);
}

class AppTheme {
  AppTheme._();

  static ThemeData get darkNeonTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: NeonColors.background,
      colorScheme: const ColorScheme.dark(
        primary: NeonColors.cyan,
        onPrimary: Colors.black,
        secondary: NeonColors.purple,
        tertiary: NeonColors.pink,
        surface: NeonColors.surface,
        error: NeonColors.danger,
      ),
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? NeonColors.cyan
              : Colors.white54,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? NeonColors.cyan.withValues(alpha: 0.4)
              : Colors.white24,
        ),
      ),
    );
  }
}
