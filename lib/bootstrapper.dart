import 'package:dragonator/commands/get_user_command.dart';
import 'package:dragonator/models/app_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models/roster_model.dart';

class Bootstrapper {
  final FirebaseAuth firebaseAuth;
  final AppModel appModel;
  final RosterModel rosterModel;

  Bootstrapper({
    required this.appModel,
    required this.rosterModel,
  }) : firebaseAuth = FirebaseAuth.instance;

  Future<void> initializeApp() async {
    await _loadUser();
    await rosterModel.initialize(appModel.user);
    appModel.isInitialized = true;
  }

  Future<void> _loadUser() async {
    final User user = firebaseAuth.currentUser!;
    appModel.user = await GetUserCommand.run(user);
  }
}