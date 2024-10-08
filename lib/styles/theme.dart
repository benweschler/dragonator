import 'package:flutter/material.dart';

//TODO: add divider theme equal to divider at top of nav bar

enum ThemeType { light, dark }

class AppColors extends ThemeExtension<AppColors> {
  static const _primaryRed = Color(0xFFE55C45);

  final Color accent;
  final Color smallSurface;
  final Color largeSurface;
  final Color errorSurface;
  final Color neutralContent;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color tabHighlightColor;
  final Color responsiveOverlayColor;
  final bool isDark;

  const AppColors._({
    required this.accent,
    required this.smallSurface,
    required this.largeSurface,
    required this.errorSurface,
    required this.neutralContent,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.tabHighlightColor,
    required this.responsiveOverlayColor,
    required this.isDark,
  });

  factory AppColors.fromType(ThemeType t) {
    switch (t) {
      case ThemeType.light:
        return AppColors._(
          accent: _primaryRed,
          smallSurface: Colors.black.withOpacity(0.07),
          largeSurface: Colors.black.withOpacity(0.04),
          errorSurface: _primaryRed.withOpacity(0.25),
          neutralContent: Colors.black.withOpacity(0.5),
          primaryContainer: Colors.black,
          onPrimaryContainer: Colors.white,
          tabHighlightColor: _primaryRed.withOpacity(0.2),
          responsiveOverlayColor: Colors.white.withOpacity(0.5),
          isDark: false,
        );
      case ThemeType.dark:
        return AppColors._(
          accent: _primaryRed,
          smallSurface: Colors.white.withOpacity(0.07),
          largeSurface: Colors.white.withOpacity(0.04),
          errorSurface: _primaryRed.withOpacity(0.25),
          neutralContent: Colors.white.withOpacity(0.5),
          primaryContainer: Colors.white,
          onPrimaryContainer: Colors.black,
          tabHighlightColor: _primaryRed.withOpacity(0.5),
          responsiveOverlayColor: Colors.black.withOpacity(0.5),
          isDark: true,
        );
    }
  }

  ThemeData toThemeData() {
    final themeData = ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      checkboxTheme: const CheckboxThemeData(
        splashRadius: 0,
        visualDensity: VisualDensity(horizontal: VisualDensity.minimumDensity),
      ),
    ).copyWith(extensions: <ThemeExtension<dynamic>>[this]);

    return themeData.copyWith(
      colorScheme: themeData.colorScheme.copyWith(primary: accent),
    );
  }

  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>()!;

  @override
  AppColors copyWith({
    Color? accent,
    Color? smallSurface,
    Color? largeSurface,
    Color? errorSurface,
    Color? neutralContent,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? tabHighlightColor,
    Color? responsiveOverlayColor,
    bool? isDark,
  }) {
    return AppColors._(
      accent: accent ?? this.accent,
      smallSurface: smallSurface ?? this.smallSurface,
      largeSurface: largeSurface ?? this.largeSurface,
      errorSurface: errorSurface ?? this.errorSurface,
      neutralContent: neutralContent ?? this.neutralContent,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      tabHighlightColor: tabHighlightColor ?? this.tabHighlightColor,
      responsiveOverlayColor:
          responsiveOverlayColor ?? this.responsiveOverlayColor,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;

    return AppColors._(
      accent: Color.lerp(accent, other.accent, t)!,
      smallSurface: Color.lerp(smallSurface, other.smallSurface, t)!,
      largeSurface: Color.lerp(largeSurface, other.largeSurface, t)!,
      errorSurface: Color.lerp(errorSurface, other.errorSurface, t)!,
      neutralContent: Color.lerp(neutralContent, other.neutralContent, t)!,
      primaryContainer:
          Color.lerp(primaryContainer, other.primaryContainer, t)!,
      onPrimaryContainer:
          Color.lerp(onPrimaryContainer, other.onPrimaryContainer, t)!,
      tabHighlightColor:
          Color.lerp(tabHighlightColor, other.tabHighlightColor, t)!,
      responsiveOverlayColor:
          Color.lerp(responsiveOverlayColor, other.responsiveOverlayColor, t)!,
      isDark: t < 0.5 ? isDark : other.isDark,
    );
  }
}
