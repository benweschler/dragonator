import 'package:dragonator/commands/users/get_user_command.dart';
import 'package:dragonator/models/app_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Bootstrapper {
  final FirebaseAuth firebaseAuth;
  final AppModel appModel;

  Bootstrapper(this.appModel) : firebaseAuth = FirebaseAuth.instance;

  Future<void> initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));

    await _loadUser();

    appModel.isInitialized = true;
  }

  Future<void> _loadUser() async {
    print('loading user');
    final User user = firebaseAuth.currentUser!;
    appModel.user = await GetUserCommand.run(user);
    print('user loaded');
  }
}