import 'package:flutter/material.dart';

//TODO: add divider theme equal to divider at top of nav bar

enum ThemeType {
  light,
}

class AppColors extends ThemeExtension<AppColors> {
  final Color accent = const Color(0xFFE55C45);
  final Color neutralHighlight;
  final Color captionColor;
  final bool isDark;

  const AppColors._({
    required this.neutralHighlight,
    required this.captionColor,
    required this.isDark,
  });

  factory AppColors.fromType(ThemeType t) {
    switch (t) {
      case ThemeType.light:
        return const AppColors._(
          neutralHighlight: Color(0x14000000),
          captionColor: Color(0x99000000),
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
    Color? neutralHighlight,
    Color? captionColor,
    bool? isDark,
  }) {
    return AppColors._(
      neutralHighlight: neutralHighlight ?? this.neutralHighlight,
      captionColor: captionColor ?? this.captionColor,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;

    return AppColors._(
      neutralHighlight:
          Color.lerp(neutralHighlight, other.neutralHighlight, t)!,
      captionColor: Color.lerp(captionColor, other.captionColor, t)!,
      isDark: t < 0.5 ? isDark : other.isDark,
    );
  }
}
