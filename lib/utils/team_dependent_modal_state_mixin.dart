import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/utils/navigation_utils.dart';
import 'package:dragonator/widgets/popups/team_deleted_popup.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

mixin TeamDependentModalStateMixin<T extends StatefulWidget> on State<T> {
  late final RosterModel _rosterModel;

  String get teamID;

  @override
  void initState() {
    super.initState();
    _rosterModel = context.read<RosterModel>();
    _rosterModel.addOnTeamDeletedListener(teamID, _checkTeamDeleted);
  }

  @override
  void dispose() {
    cancelTeamDependence();
    super.dispose();
  }

  void cancelTeamDependence() =>
      _rosterModel.removeOnTeamDeletedListener(teamID, _checkTeamDeleted);

  void _checkTeamDeleted() {
    Navigator.of(context).pop();
    context.showPopup(TeamDeletedPopup());
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
