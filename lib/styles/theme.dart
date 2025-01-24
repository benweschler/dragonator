import 'package:flutter/material.dart';

//TODO: add divider theme equal to divider at top of nav bar

enum ThemeType { light, dark }

class AppColors extends ThemeExtension<AppColors> {
  static const _primaryRed = Color(0xFFE55C45);

  final Color primary;
  final Color background;
  final Color onBackground;
  final Color smallSurface;
  final Color largeSurface;
  final Color primarySurface;
  final Color error;
  final Color smallErrorSurface;
  final Color largeErrorSurface;
  final Color neutralContent;
  final Color buttonContainer;
  final Color onButtonContainer;
  final Color tabHighlight;
  final Color responsiveOverlay;
  final Color outline;
  final Color outlineVariant;
  final bool isDark;

  const AppColors._({
    required this.primary,
    required this.background,
    required this.onBackground,
    required this.smallSurface,
    required this.largeSurface,
    required this.primarySurface,
    required this.error,
    required this.smallErrorSurface,
    required this.largeErrorSurface,
    required this.neutralContent,
    required this.buttonContainer,
    required this.onButtonContainer,
    required this.tabHighlight,
    required this.responsiveOverlay,
    required this.outline,
    required this.outlineVariant,
    required this.isDark,
  });

  factory AppColors.fromType(ThemeType t) {
    switch (t) {
      case ThemeType.light:
        return AppColors._(
          primary: _primaryRed,
          // The default M3 light on/surface color.
          background: Color(0xFFFEF7FF),
          onBackground: Color(0xFF1D1B20),
          smallSurface: Colors.black.withValues(alpha: 0.07),
          largeSurface: Colors.black.withValues(alpha: 0.04),
          primarySurface: _primaryRed.withValues(alpha: 0.1),
          error: Color(0xFFB3261E),
          smallErrorSurface: Color(0xFFeb3026).withValues(alpha: 0.2),
          largeErrorSurface: Color(0xFFeb3026).withValues(alpha: 0.1),
          neutralContent: Colors.black.withValues(alpha: 0.5),
          buttonContainer: Colors.black,
          onButtonContainer: Colors.white,
          tabHighlight: _primaryRed.withValues(alpha: 0.35),
          responsiveOverlay: Colors.white.withValues(alpha: 0.5),
          // The default M3 light outline/variant color.
          outline: Color(0xFF79747E),
          outlineVariant: Color(0xFFCAC4D0),
          isDark: false,
        );
      case ThemeType.dark:
        return AppColors._(
          primary: _primaryRed,
          // The default M3 dark on/surface color.
          background: Color(0xFF141218),
          onBackground: Color(0xFFE6E0E9),
          smallSurface: Colors.white.withValues(alpha: 0.07),
          largeSurface: Colors.white.withValues(alpha: 0.04),
          primarySurface: _primaryRed.withValues(alpha: 0.1),
          error: Color(0xFFF54D47),
          smallErrorSurface: Color(0xFFF54D47).withValues(alpha: 0.35),
          largeErrorSurface: Color(0xFFF54D47).withValues(alpha: 0.125),
          neutralContent: Colors.white.withValues(alpha: 0.5),
          buttonContainer: Colors.white,
          onButtonContainer: Colors.black,
          // Meets 3:1 contrast on background.
          tabHighlight: _primaryRed.withValues(alpha: 0.68),
          responsiveOverlay: Colors.black.withValues(alpha: 0.5),
          // The default M3 light outline/variant color.
          outline: Color(0xFF938F99),
          outlineVariant: Color(0xFF49454F),
          isDark: true,
        );
    }
  }

  ThemeData toThemeData() {
    return ThemeData(
      useMaterial3: true,
      splashFactory: NoSplash.splashFactory,
      colorScheme: ThemeData().colorScheme.copyWith(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primary,
        surface: background,
        onSurface: onBackground,
        outline: outline,
        outlineVariant: outlineVariant,
      ),
    ).copyWith(extensions: <ThemeExtension<dynamic>>[this]);
  }

  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>()!;

  @override
  AppColors copyWith({
    Color? primary,
    Color? background,
    Color? onBackground,
    Color? smallSurface,
    Color? largeSurface,
    Color? primarySurface,
    Color? error,
    Color? smallErrorSurface,
    Color? largeErrorSurface,
    Color? neutralContent,
    Color? buttonContainer,
    Color? onButtonContainer,
    Color? tabHighlight,
    Color? responsiveOverlay,
    Color? outline,
    Color? outlineVariant,
    bool? isDark,
  }) {
    return AppColors._(
      primary: primary ?? this.primary,
      background: background ?? this.background,
      onBackground: onBackground ?? this.onBackground,
      smallSurface: smallSurface ?? this.smallSurface,
      largeSurface: largeSurface ?? this.largeSurface,
      primarySurface: primarySurface ?? this.primarySurface,
      error: error ?? this.error,
      smallErrorSurface: smallErrorSurface ?? this.smallErrorSurface,
      largeErrorSurface: largeErrorSurface ?? this.largeErrorSurface,
      neutralContent: neutralContent ?? this.neutralContent,
      buttonContainer: buttonContainer ?? this.buttonContainer,
      onButtonContainer: onButtonContainer ?? this.onButtonContainer,
      tabHighlight: tabHighlight ?? this.tabHighlight,
      responsiveOverlay: responsiveOverlay ?? this.responsiveOverlay,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;

    return AppColors._(
      primary: Color.lerp(primary, other.primary, t)!,
      background: Color.lerp(background, other.background, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      smallSurface: Color.lerp(smallSurface, other.smallSurface, t)!,
      largeSurface: Color.lerp(largeSurface, other.largeSurface, t)!,
      primarySurface: Color.lerp(primarySurface, other.primarySurface, t)!,
      error: Color.lerp(error, other.error, t)!,
      smallErrorSurface: Color.lerp(smallErrorSurface, other.smallErrorSurface, t)!,
      largeErrorSurface: Color.lerp(largeErrorSurface, other.largeErrorSurface, t)!,
      neutralContent: Color.lerp(neutralContent, other.neutralContent, t)!,
      buttonContainer: Color.lerp(buttonContainer, other.buttonContainer, t)!,
      onButtonContainer:
          Color.lerp(onButtonContainer, other.onButtonContainer, t)!,
      tabHighlight: Color.lerp(tabHighlight, other.tabHighlight, t)!,
      responsiveOverlay:
          Color.lerp(responsiveOverlay, other.responsiveOverlay, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      outlineVariant: Color.lerp(outlineVariant, other.outlineVariant, t)!,
      isDark: t < 0.5 ? isDark : other.isDark,
    );
  }
}
