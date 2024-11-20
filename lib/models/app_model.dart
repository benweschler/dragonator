import 'package:dragonator/data/app_user.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' show ThemeMode;

class AppModel extends Notifier {
  final Notifier routerRefreshNotifier = Notifier();

  AppModel() {
    FirebaseAuth.instance.authStateChanges().listen((authUser) {
      _isLoggedIn = authUser != null;
      if (_user != null && authUser == null) {
        _isInitialized = false;
        _user = null;
      }
      routerRefreshNotifier.notify();
    });
  }

  /// Whether a user is logged into the app.
  bool _isLoggedIn = false;

  /// Whether the app has been initialized with user data.
  bool _isInitialized = false;

  /// The active theme for the app.
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  set themeMode(themeMode) => notify(() => _themeMode = themeMode);

  ThemeType get lightThemeType {
    if (themeMode == ThemeMode.dark) return ThemeType.dark;
    return ThemeType.light;
  }

  ThemeType get darkThemeType {
    if (themeMode == ThemeMode.light) return ThemeType.light;
    return ThemeType.dark;
  }

  /// The user that is currently signed in.
  AppUser? _user;

  bool get isLoggedIn => _isLoggedIn;

  bool get isInitialized => _isInitialized;

  set isInitialized(bool value) {
    _isInitialized = value;
    routerRefreshNotifier.notify();
  }

  AppUser get user {
    if (_user == null) {
      throw Exception('The user was accessed when no user is logged in.');
    }

    return _user!;
  }

  set user(AppUser? user) => notify(() => _user = user);
}
