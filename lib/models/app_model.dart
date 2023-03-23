import 'package:dragonator/bootstrapper.dart';
import 'package:dragonator/data/app_user.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/easy_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppModel extends EasyNotifier {
  static const ThemeType _defaultThemeType = ThemeType.light;
  final EasyNotifier routerRefreshNotifier = EasyNotifier();

  AppModel() {
    FirebaseAuth.instance.authStateChanges().listen((authUser) {
      _isLoggedIn = authUser != null;
      if (user != null && authUser == null) {
        _isInitialized = false;
        user = null;
      }
      routerRefreshNotifier.notifyListeners();
    });
  }

  /// Whether a user is logged into the app.
  bool _isLoggedIn = false;

  /// Whether the app has been initialized with user data.
  bool _isInitialized = false;

  /// The active theme for the app.
  ThemeType _themeType = _defaultThemeType;

  /// The user that is currently signed in.
  AppUser? _user;

  bool get isLoggedIn => _isLoggedIn;

  bool get isInitialized => _isInitialized;

  set isInitialized(bool value) {
    _isInitialized = value;
    routerRefreshNotifier.notifyListeners();
  }

  ThemeType get themeType => _themeType;

  set themeType(ThemeType theme) => notify(() => _themeType = theme);

  AppUser? get user => _user;

  set user(AppUser? user) => notify(() => _user = user);

  Future<void> initializeApp() => Bootstrapper(this).initializeApp();
}
