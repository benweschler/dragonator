import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/navigation_utils.dart';
import 'package:dragonator/widgets/buttons/expanding_buttons.dart';
import 'package:dragonator/widgets/popup_dialog.dart';
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
    _rosterModel.addListener(_checkTeamDeleted);
  }

  @override
  void dispose() {
    _rosterModel.removeListener(_checkTeamDeleted);
    super.dispose();
  }

  //TODO: eventually add onTeamDeletedListeners in RosterModel
  void _checkTeamDeleted() {
    if (context.read<RosterModel>().getTeam(teamID) == null) {
      Navigator.of(context).pop();
      //TODO: showing this popup should be managed by the roster model globally when the current team is deleted, and should be managed by an onTeamDeletedListener when not.
      context.showPopup(_TeamDeletedPopup());
    }
  }
}

class _TeamDeletedPopup extends StatelessWidget {
  const _TeamDeletedPopup();

  @override
  Widget build(BuildContext context) {
    return PopupDialog(
      child: Padding(
        padding: EdgeInsets.all(Insets.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Team Deleted', style: TextStyles.title1),
            const SizedBox(height: Insets.med),
            Text(
              'This team has been deleted by another collaborator.',
              style: TextStyles.body1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Insets.xl),
            ExpandingStadiumButton(
              onTap: Navigator.of(context).pop,
              color: AppColors.of(context).primary,
              label: 'Done',
            ),
            SizedBox(height: Insets.sm),
          ],
        ),
      ),
    );
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
