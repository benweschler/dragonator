import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/utils/navigation_utils.dart';
import 'package:dragonator/widgets/popups/team_deleted_popup.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
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
    // Allow the roster model to handle showing the team deleted popup and
    // popping to the root route if the dependency is on the current team.
    if(isCurrentTeam) return;
    Navigator.of(context).pop();
    context.showPopup(TeamDeletedPopup(teamName));
    cancelTeamDependence();
  }
}

//TODO: this gotta go somewhere else
class PopupTransitionPage<T> extends CustomTransitionPage<T> {
  PopupTransitionPage({required super.child})
      : super(
          transitionDuration: Duration(milliseconds: 250),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        );
}
