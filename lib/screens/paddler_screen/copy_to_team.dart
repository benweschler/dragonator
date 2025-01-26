import 'package:dragonator/data/paddler/paddler.dart';
import 'package:dragonator/data/team/team.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/navigation_utils.dart';
import 'package:dragonator/widgets/buttons/expanding_buttons.dart';
import 'package:dragonator/widgets/modal_sheets/selection_menu.dart';
import 'package:dragonator/widgets/popups/popup_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CopyPaddlerToTeamMenu extends StatelessWidget {
  final Paddler paddler;

  const CopyPaddlerToTeamMenu(this.paddler, {super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<RosterModel, Iterable<Team>>(
      selector: (context, model) => model.teams,
      builder: (context, teams, _) {
        final rosterModel = context.read<RosterModel>();

        return SelectionMenu.multi(
          options: teams.toSet()..remove(rosterModel.currentTeam),
          labelBuilder: (team) => team.name,
          onSelect: (Set<Team> teams) async {
            final confirmation =
                await context.showPopup<bool>(_CopyPaddlerConfirmationPopup(
                  multipleTeams: teams.length > 1,
                )) ??
                    false;

            if (!confirmation) return;

            for (var team in teams) {
              await rosterModel.copyPaddlerToTeam(paddler, team.id);
            }
            if (context.mounted) context.pop();
          },
        );
      },
    );
  }
}

class _CopyPaddlerConfirmationPopup extends StatelessWidget {
  final bool multipleTeams;

  const _CopyPaddlerConfirmationPopup({required this.multipleTeams});

  @override
  Widget build(BuildContext context) {
    return PopupDialog(
      child: Padding(
        padding: EdgeInsets.all(Insets.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Confirm Adding Paddler', style: TextStyles.title1),
            SizedBox(height: Insets.lg),
            Text(
              'If this paddler already exists in ${multipleTeams ? 'these teams' : 'this team'}, this will create a duplicate.\n\nAre you sure you want to continue?',
            ),
            SizedBox(height: Insets.xl),
            ExpandingStadiumButton(
              onTap: () => Navigator.pop(context, true),
              color: AppColors.of(context).primary,
              label: 'Confirm',
            ),
            SizedBox(height: Insets.sm),
            ExpandingTextButton(
              onTap: () => Navigator.pop(context, false),
              text: 'Cancel',
            ),
          ],
        ),
      ),
    );
  }
}
