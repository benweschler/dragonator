import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/notifier.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:shared_preferences/shared_preferences.dart';

/// The default theme mode, used when the user is not logged in.
const ThemeMode _kDefaultThemeMode = ThemeMode.system;

class SettingsModel extends Notifier {
  late final SharedPreferencesWithCache _sharedPreferences;
  bool _isInitialized = false;

  Future<void> initialize() async {
    _sharedPreferences = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(
        allowList: {'theme', 'show-com-overlay'},
      ),
    );
    _isInitialized = true;
    notify();
  }

  /// The active theme for the app.
  ThemeMode get themeMode {
    if(!_isInitialized) return _kDefaultThemeMode;

    final pref = _sharedPreferences.getString('theme');
    return switch (pref) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => _kDefaultThemeMode,
    };
  }

  setThemeMode(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        _sharedPreferences.setString('theme', 'light');
      case ThemeMode.dark:
        _sharedPreferences.setString('theme', 'dark');
      case ThemeMode.system:
        _sharedPreferences.setString('theme', 'system');
    }
    notify();
  }


  ThemeType get lightThemeType {
    if (themeMode == ThemeMode.dark) return ThemeType.dark;
    return ThemeType.light;
  }

  ThemeType get darkThemeType {
    if (themeMode == ThemeMode.light) return ThemeType.light;
    return ThemeType.dark;
  }

  bool get showComOverlay =>
      _sharedPreferences.getBool('show-com-overlay') ?? false;

  setShowComOverlay(bool showComOverlay) {
    switch (showComOverlay) {
      case true:
        _sharedPreferences.setBool('show-com-overlay', true);
      case false:
        _sharedPreferences.setBool('show-com-overlay', false);
    }
    notify();
  }
}
