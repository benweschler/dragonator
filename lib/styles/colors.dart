import 'package:flutter/material.dart';

enum ThemeType {
  light,
}

class AppColors extends ThemeExtension<AppColors> {
  final Color neutralHighlight;

  const AppColors({required this.neutralHighlight});

  factory AppColors.fromType(ThemeType t) {
    switch (t) {
      case ThemeType.light:
        return AppColors(
          neutralHighlight: Colors.black.withOpacity(0.1),
        );
    }
  }

  ThemeData toThemeData() =>
      ThemeData().copyWith(extensions: <ThemeExtension<dynamic>>[this]);

  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>()!;

  @override
  AppColors copyWith({Color? neutralHighlight}) {
    return AppColors(
      neutralHighlight: neutralHighlight ?? this.neutralHighlight,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;

    return AppColors(
      neutralHighlight:
          Color.lerp(neutralHighlight, other.neutralHighlight, t)!,
    );
  }
}
