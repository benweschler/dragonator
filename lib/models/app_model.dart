import 'package:dragonator/commands/user_commands.dart';
import 'package:dragonator/data/user/app_user.dart';
import 'package:dragonator/utils/notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppModel extends Notifier {
  final Notifier routerRefreshNotifier = Notifier();

  AppModel() {
    FirebaseAuth.instance.authStateChanges().listen((authUser) {
      _isLoggedIn = authUser != null;
      if (_user != null && authUser == null) {
        _isAppInitialized = false;
        _user = null;
      }
      routerRefreshNotifier.notify();
    });
  }

  //TODO: user and app management should be move to auth state changes?
  Future<void> loadUser() async {
    _user = await getUserCommand(FirebaseAuth.instance.currentUser!.uid);
  }

  /// Whether a user is logged into the app.
  bool _isLoggedIn = false;

  /// Whether the app has been initialized with user data.
  bool _isAppInitialized = false;

  /// The user that is currently signed in.
  AppUser? _user;

  bool get isLoggedIn => _isLoggedIn;

  bool get isAppInitialized => _isAppInitialized;

  set isAppInitialized(bool value) {
    _isAppInitialized = value;
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
