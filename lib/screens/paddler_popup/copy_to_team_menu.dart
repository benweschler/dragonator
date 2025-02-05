import 'package:dragonator/data/paddler/paddler.dart';
import 'package:dragonator/data/team/team.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/utils/navigation_utils.dart';
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

  Future<void> _onSelectTeam(Set<Team> teams, RosterModel rosterModel) async {
    await Future.delayed(Timings.long);

    if (!popupContext.mounted) return;

    final userConfirmation = await Navigator.of(popupContext).pushNamed<bool>(
      appendQueryParams(
        '/copy-to-team',
        {'multiple-teams': '${teams.length > 1}'},
      ),
    );
    final confirmation = userConfirmation ?? false;

    if (!confirmation) return;

    for (var team in teams) {
      await rosterModel.copyPaddlerToTeam(paddler, team.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selector<RosterModel, Iterable<Team>>(
      selector: (context, model) => model.teams,
      builder: (context, teams, _) {
        final rosterModel = context.read<RosterModel>();

        return SelectionMenu.multi(
          options: teams.toSet()..remove(rosterModel.currentTeam),
          labelBuilder: (team) => team.name,
          onSelect: (teams) => _onSelectTeam(teams, rosterModel),
        );
      },
    );
  }
}
