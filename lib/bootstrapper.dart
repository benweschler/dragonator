import 'package:dragonator/commands/user_commands.dart';
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

  //TODO: move this to AppModel, move user commands to app model, and open realtime listener.
  Future<void> _loadUser() async {
    appModel.user = await getUserCommand(firebaseAuth.currentUser!.uid);
  }
}