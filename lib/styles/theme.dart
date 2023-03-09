import 'package:flutter/material.dart';

//TODO: add divider theme equal to divider at top of nav bar

enum ThemeType {
  light,
}

class AppColors extends ThemeExtension<AppColors> {
  final Color neutralHighlight;
  final Color captionColor;

  const AppColors({
    required this.neutralHighlight,
    required this.captionColor,
  });

  factory AppColors.fromType(ThemeType t) {
    switch (t) {
      case ThemeType.light:
        return const AppColors(
          neutralHighlight: Color(0x14000000),
          captionColor: Color(0x99000000),
        );
    }
  }

  ThemeData toThemeData() =>
      ThemeData().copyWith(extensions: <ThemeExtension<dynamic>>[this]);

  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>()!;

  @override
  AppColors copyWith({Color? neutralHighlight, Color? captionColor}) {
    return AppColors(
      neutralHighlight: neutralHighlight ?? this.neutralHighlight,
      captionColor: captionColor ?? this.captionColor,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;

    return AppColors(
      neutralHighlight: Color.lerp(neutralHighlight, other.neutralHighlight, t)!,
      captionColor: Color.lerp(captionColor, other.captionColor, t)!,
    );
  }
}
