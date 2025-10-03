import 'package:flutter/material.dart';

class AppTheme {
  static const _midnightTealColor = Color(0xFF22D3EE);

  static ThemeData buildDarkTheme() {
    const seed = _midnightTealColor;
    final scheme = ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: seed,
    ).copyWith(surface: const Color(0xFF0B1014));

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
        hintStyle: TextStyle(color: scheme.onSurface.withValues(alpha: 0.6)),
      ),
      textTheme: TextTheme(),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
