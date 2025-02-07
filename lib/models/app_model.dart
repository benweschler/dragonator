import 'package:dragonator/commands/user_commands.dart';
import 'package:dragonator/data/user/app_user.dart';
import 'package:dragonator/utils/notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'roster_model.dart';
import 'settings_model.dart';

//TODO: must add realtime listener to user doc.
class AppModel extends Notifier {
  final Notifier routerRefreshNotifier = Notifier();

  AppModel() {
    FirebaseAuth.instance.authStateChanges().listen((authUser) {
      _isLoggedIn = authUser != null;
      if (_user != null && authUser == null) {
        _isAppInitialized = false;
        _user = null;
      }
      routerRefreshNotifier.notifyListeners();
    });
  }

  //TODO: user and app management should be move to auth state changes?
  Future<void> loadUser() async {
    _user = await getUserCommand(FirebaseAuth.instance.currentUser!.uid);
  }

  Future<void> logIn({required String email, required String password}) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logOut(BuildContext context) {
    context.read<RosterModel>().clear();
    context.read<SettingsModel>().clear();
    return FirebaseAuth.instance.signOut();
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
    routerRefreshNotifier.notifyListeners();
  }

  AppUser get user {
    if (_user == null) {
      throw Exception('The user was accessed when no user is logged in.');
    }

    return _user!;
  }

  set user(AppUser? user) => notifyListeners(() => _user = user);
}
