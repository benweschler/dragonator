import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragonator/commands/firestore_references.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:shared_preferences/shared_preferences.dart';

part '../commands/settings_commands.dart';

/// The default theme mode, used when the user is not logged in.
const ThemeMode _kDefaultThemeMode = ThemeMode.system;

class SettingsModel extends Notifier {
  late final SharedPreferencesWithCache _sharedPreferences;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (!_isInitialized) {
      _sharedPreferences = await SharedPreferencesWithCache.create(
        cacheOptions: SharedPreferencesWithCacheOptions(
          allowList: {themeKey, showComKey},
        ),
      );
      _isInitialized = true;
    }
    _updateFromFirestore();
    notify();
  }

  /// Deletes the stored preferences. Should be used when a user logs out.
  void clear() {
    if (_isInitialized) _sharedPreferences.clear();
    notify();
  }

  void _updateFromFirestore() async {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    if (userID == null) return;

    final data = await _getSettingsCommand(userID);

    // Allow different devices to use different theme modes. Only pull the most
    // recently used theme mode pulled from Firestore if there is no stored
    // theme mode.
    final storedThemePref = _sharedPreferences.getString(themeKey);
    if (storedThemePref == null && data.containsKey(themeKey)) {
      setThemeMode(data[themeKey]);
    }
    // Always pull COM overlay preferences from Firestore.
    if (data.containsKey(showComKey)) {
      setShowComOverlay(data[showComKey]);
    }
  }

  //* SETTINGS GETTERS *//

  /// The active theme for the app.
  ThemeMode get themeMode {
    if (!_isInitialized) return _kDefaultThemeMode;

    final pref = _sharedPreferences.getString(themeKey);
    return switch (pref) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => _kDefaultThemeMode,
    };
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
      _sharedPreferences.getBool(showComKey) ?? false;

  //* SETTINGS SETTERS *//

  //TODO: theme mode and com overlay probably don't have to be stored in a database. Store more important settings once present (i.e. make discoverable).
  setThemeMode(ThemeMode themeMode) {
    _sharedPreferences.setString(themeKey, themeMode.name);
    final userID = FirebaseAuth.instance.currentUser!.uid;
    _setSettingsCommand({themeKey: themeMode.name}, userID);
    notify();
  }

  setShowComOverlay(bool showComOverlay) {
    _sharedPreferences.setBool(showComKey, showComOverlay);
    final userID = FirebaseAuth.instance.currentUser!.uid;
    _setSettingsCommand({showComKey: showComOverlay}, userID);
    notify();
  }
}
