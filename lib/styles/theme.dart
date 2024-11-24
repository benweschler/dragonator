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
  final Color errorSurface;
  final Color neutralContent;
  final Color buttonContainer;
  final Color onButtonContainer;
  final Color tabHighlightColor;
  final Color responsiveOverlayColor;
  final Color outline;
  final Color outlineVariant;
  final bool isDark;

  const AppColors._({
    required this.primary,
    required this.background,
    required this.onBackground,
    required this.smallSurface,
    required this.largeSurface,
    required this.errorSurface,
    required this.neutralContent,
    required this.buttonContainer,
    required this.onButtonContainer,
    required this.tabHighlightColor,
    required this.responsiveOverlayColor,
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
          smallSurface: Colors.black.withOpacity(0.07),
          largeSurface: Colors.black.withOpacity(0.04),
          errorSurface: _primaryRed.withOpacity(0.25),
          neutralContent: Colors.black.withOpacity(0.5),
          buttonContainer: Colors.black,
          onButtonContainer: Colors.white,
          tabHighlightColor: _primaryRed.withOpacity(0.4),
          responsiveOverlayColor: Colors.white.withOpacity(0.5),
          outline: Color(0xFF79747E),
          outlineVariant: Color(0xFFCAC4D0),
          isDark: false,
        );
      case ThemeType.dark:
        return AppColors._(
          primary: _primaryRed,
          //TODO: maybe alpha blend surfaces here rather than in UI
          // The default M3 dark on/surface color.
          background: Color(0xFF141218),
          onBackground: Color(0xFFE6E0E9),
          smallSurface: Colors.white.withOpacity(0.07),
          largeSurface: Colors.white.withOpacity(0.04),
          errorSurface: _primaryRed.withOpacity(0.35),
          neutralContent: Colors.white.withOpacity(0.5),
          buttonContainer: Colors.white,
          onButtonContainer: Colors.black,
          // Meets 3:1 contrast on background.
          tabHighlightColor: _primaryRed.withOpacity(0.68),
          responsiveOverlayColor: Colors.black.withOpacity(0.5),
          outline: Color(0xFF938F99),
          outlineVariant: Color(0xFF49454F),
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
      colorScheme: themeData.colorScheme.copyWith(
        primary: primary,
        surface: background,
        onSurface: onBackground,
        outline: outline,
        outlineVariant: outlineVariant,
      ),
    );
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
    Color? errorSurface,
    Color? neutralContent,
    Color? buttonContainer,
    Color? onButtonContainer,
    Color? tabHighlightColor,
    Color? responsiveOverlayColor,
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
      errorSurface: errorSurface ?? this.errorSurface,
      neutralContent: neutralContent ?? this.neutralContent,
      buttonContainer: buttonContainer ?? this.buttonContainer,
      onButtonContainer: onButtonContainer ?? this.onButtonContainer,
      tabHighlightColor: tabHighlightColor ?? this.tabHighlightColor,
      responsiveOverlayColor:
          responsiveOverlayColor ?? this.responsiveOverlayColor,
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
      errorSurface: Color.lerp(errorSurface, other.errorSurface, t)!,
      neutralContent: Color.lerp(neutralContent, other.neutralContent, t)!,
      buttonContainer: Color.lerp(buttonContainer, other.buttonContainer, t)!,
      onButtonContainer:
          Color.lerp(onButtonContainer, other.onButtonContainer, t)!,
      tabHighlightColor:
          Color.lerp(tabHighlightColor, other.tabHighlightColor, t)!,
      responsiveOverlayColor:
          Color.lerp(responsiveOverlayColor, other.responsiveOverlayColor, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      outlineVariant: Color.lerp(outlineVariant, other.outlineVariant, t)!,
      isDark: t < 0.5 ? isDark : other.isDark,
    );
  }
}
