import 'package:dragonator/models/app_model.dart';
import 'package:dragonator/models/settings_model.dart';

import 'models/roster_model.dart';

class Bootstrapper {
  final AppModel appModel;
  final RosterModel rosterModel;
  final SettingsModel settingsModel;

  Bootstrapper({
    required this.appModel,
    required this.rosterModel,
    required this.settingsModel,
  });

  Future<void> initializeApp() async {
    await appModel.loadUser();
    await rosterModel.initialize(appModel.user);
    await settingsModel.initialize();
    appModel.isAppInitialized = true;
  }
}