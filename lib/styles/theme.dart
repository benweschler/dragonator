import 'package:flutter/material.dart';

//TODO: add divider theme equal to divider at top of nav bar

enum ThemeType {
  light,
}

class AppColors extends ThemeExtension<AppColors> {
  final Color accent = const Color(0xFFE55C45);
  final Color neutralSurface;
  final Color neutralContent;
  final bool isDark;

  const AppColors._({
    required this.neutralSurface,
    required this.neutralContent,
    required this.isDark,
  });

  factory AppColors.fromType(ThemeType t) {
    switch (t) {
      case ThemeType.light:
        return AppColors._(
          neutralSurface: Colors.black.withOpacity(0.08),
          neutralContent: Colors.black.withOpacity(0.5),
          isDark: false,
        );
    }
  }

  ThemeData toThemeData() => ThemeData(
        brightness: isDark ? Brightness.dark : Brightness.light,
      ).copyWith(extensions: <ThemeExtension<dynamic>>[this]);

  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>()!;

  @override
  AppColors copyWith({
    Color? neutralSurface,
    Color? onNeutralSurface,
    Color? neutralContent,
    bool? isDark,
  }) {
    return AppColors._(
      neutralSurface: neutralSurface ?? this.neutralSurface,
      neutralContent: neutralContent ?? this.neutralContent,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;

    return AppColors._(
      neutralSurface: Color.lerp(neutralSurface, other.neutralSurface, t)!,
      neutralContent: Color.lerp(neutralContent, other.neutralContent, t)!,
      isDark: t < 0.5 ? isDark : other.isDark,
    );
  }
}
