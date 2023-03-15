import 'package:flutter/material.dart';

//TODO: add divider theme equal to divider at top of nav bar

enum ThemeType {
  light,
}

class AppColors extends ThemeExtension<AppColors> {
  final Color accent = const Color(0xFFE55C45);
  final Color smallSurface;
  final Color largeSurface;
  final Color neutralContent;
  final bool isDark;

  const AppColors._({
    required this.smallSurface,
    required this.largeSurface,
    required this.neutralContent,
    required this.isDark,
  });

  factory AppColors.fromType(ThemeType t) {
    switch (t) {
      case ThemeType.light:
        return AppColors._(
          smallSurface: Colors.black.withOpacity(0.07),
          largeSurface: Colors.black.withOpacity(0.04),
          neutralContent: Colors.black.withOpacity(0.5),
          isDark: false,
        );
    }
  }

  ThemeData toThemeData() {
    final themeData = ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      checkboxTheme: const CheckboxThemeData(
        splashRadius: 0,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity(
          horizontal: VisualDensity.minimumDensity,
          vertical: VisualDensity.minimumDensity,
        ),
      ),
    ).copyWith(extensions: <ThemeExtension<dynamic>>[this]);

    return themeData.copyWith(
        colorScheme: themeData.colorScheme.copyWith(
      primary: accent,
    ));
  }

  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>()!;

  @override
  AppColors copyWith({
    Color? smallSurface,
    Color? largeSurface,
    Color? neutralContent,
    bool? isDark,
  }) {
    return AppColors._(
      smallSurface: smallSurface ?? this.smallSurface,
      largeSurface: largeSurface ?? this.largeSurface,
      neutralContent: neutralContent ?? this.neutralContent,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;

    return AppColors._(
      smallSurface: Color.lerp(smallSurface, other.smallSurface, t)!,
      largeSurface: Color.lerp(largeSurface, other.largeSurface, t)!,
      neutralContent: Color.lerp(neutralContent, other.neutralContent, t)!,
      isDark: t < 0.5 ? isDark : other.isDark,
    );
  }
}
