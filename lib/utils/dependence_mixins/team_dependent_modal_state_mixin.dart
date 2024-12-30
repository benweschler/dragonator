import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/utils/navigation_utils.dart';
import 'package:dragonator/widgets/popups/team_deleted_popup.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

mixin TeamDependentModalStateMixin<T extends StatefulWidget> on State<T> {
  late final RosterModel _rosterModel;

  String get teamID;

  @override
  void initState() {
    super.initState();
    _rosterModel = context.read<RosterModel>();
    _rosterModel.addTeamDeletedListener(teamID, _onTeamDeleted);
  }

  @override
  void dispose() {
    cancelTeamDependence();
    super.dispose();
  }

  void cancelTeamDependence() =>
      _rosterModel.removeTeamDeletedListener(teamID, _onTeamDeleted);

  void _onTeamDeleted({required String teamName, required bool isCurrentTeam}) {
    cancelTeamDependence();
    if(!context.mounted) return;
    Navigator.of(context).pop();
    // Allow the roster model to handle showing the team deleted popup if the
    // current team is deleted.
    if(!isCurrentTeam) {
      context.showPopup(TeamDeletedPopup(teamName));
    }
  }
}
