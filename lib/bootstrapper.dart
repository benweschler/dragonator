import 'package:dragonator/models/app_model.dart';
import 'package:dragonator/models/settings_model.dart';
import 'package:dragonator/utils/navigation_utils.dart';
import 'package:dragonator/widgets/popups/team_deleted_popup.dart';
import 'package:flutter/widgets.dart';

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

  Future<void> initializeApp(BuildContext rootContext) async {
    await appModel.loadUser();
    await rosterModel.initialize(
      user: appModel.user,
      showCurrentTeamDeletedDialog: (deletedTeamName) => rootContext.showPopup(
        TeamDeletedPopup(deletedTeamName),
      ),
    );
    await settingsModel.initialize();
    appModel.isAppInitialized = true;
  }
}
