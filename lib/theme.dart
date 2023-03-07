import 'package:flutter/material.dart';

enum ThemeType {
  light,
}

class AppTheme {
  final Color accent;

  const AppTheme({required this.accent});

  factory AppTheme.fromType(ThemeType t) {
    switch (t) {
      case ThemeType.light:
        return const AppTheme(
          accent: Color(0xFF123FBA),
        );
    }
  }

  ThemeData toThemeData() {
    return ThemeData(
      colorScheme: ThemeData().colorScheme.copyWith(
            primary: accent,
            secondary: accent,
          ),
    );
  }
}
