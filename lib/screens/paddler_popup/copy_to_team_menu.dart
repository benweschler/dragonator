import 'package:dragonator/data/paddler/paddler.dart';
import 'package:dragonator/data/team/team.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/widgets/modal_sheets/selection_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CopyPaddlerToTeamMenu extends StatelessWidget {
  final Paddler paddler;
  final BuildContext popupContext;

  const CopyPaddlerToTeamMenu({
    super.key,
    required this.paddler,
    required this.popupContext,
  });

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
            await Future.delayed(Timings.long);

            if(!popupContext.mounted) return;
            final confirmation =
                await Navigator.of(popupContext).pushNamed<bool>(
                      '/copy-to-team?multiple-teams=${teams.length > 1}',
                    ) ??
                    false;

            if (!confirmation) return;

            for (var team in teams) {
              await rosterModel.copyPaddlerToTeam(paddler, team.id);
            }
          },
        );
      },
    );
  }
}
