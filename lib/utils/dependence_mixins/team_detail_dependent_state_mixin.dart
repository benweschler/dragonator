import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/utils/navigation_utils.dart';
import 'package:dragonator/widgets/popups/team_detail_deleted_popup.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

mixin TeamDetailDependentStateMixin<T extends StatefulWidget> on State<T> {
  late final RosterModel _rosterModel;
  late final String _initialTeamID;

  Object? Function() get getDetail;

  String get detailType;

  @override
  void initState() {
    super.initState();
    _rosterModel = context.read<RosterModel>();
    _rosterModel.addListener(_checkDetailDeleted);
    _initialTeamID = _rosterModel.currentTeam!.id;
  }

  @override
  void dispose() {
    cancelDetailDependence();
    super.dispose();
  }

  void cancelDetailDependence() =>
      _rosterModel.removeListener(_checkDetailDeleted);

  void _checkDetailDeleted() async {
    if (getDetail() != null) return;

    cancelDetailDependence();
    final initialTeamExists = await RosterModel.checkTeamExists(_initialTeamID);
    // Allow the roster model to handle showing the team deleted popup and
    // popping to the root route if the dependency is on a detail of current
    // team.
    if (!initialTeamExists) return;

    // These actions should still be taken even if this page is no longer
    // mounted, so use the navigator context instead of the state context.
    if (mounted) {
      context.popToRoot();
      context.showPopup(TeamDetailDeletedPopup(detailType));
    }
  }
}
