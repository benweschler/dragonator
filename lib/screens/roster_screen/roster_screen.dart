import 'dart:math';

import 'package:dragonator/data/player.dart';
import 'package:dragonator/data/team.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/router.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:dragonator/utils/navigator_utils.dart';
import 'package:dragonator/widgets/buttons/option_button.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:dragonator/widgets/buttons/custom_fab.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:dragonator/widgets/modal_sheets/selection_menu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'player_preview_card.dart';

class RosterScreen extends StatefulWidget {
  const RosterScreen({Key? key}) : super(key: key);

  @override
  State<RosterScreen> createState() => _RosterScreenState();
}

class _RosterScreenState extends State<RosterScreen> {
  int selectedTeamIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<RosterModel>(
      builder: (context, rosterModel, _) {
        final teams = rosterModel.teams.toList();

        return CustomScaffold(
          floatingActionButton: CustomFAB(
            child: const Icon(Icons.add_rounded),
            onTap: () => context.go(RoutePaths.editPlayer(
              teamID: teams[selectedTeamIndex].id,
            )),
          ),
          center: ResponsiveStrokeButton(
            onTap: () => context.showModal(SelectionMenu(
              items: teams.map((team) => team.name).toList(),
              initiallySelectedIndex: selectedTeamIndex,
              onItemTap: (newTeamIndex) {
                if (selectedTeamIndex != newTeamIndex) {
                  setState(() => selectedTeamIndex = newTeamIndex);
                }
              },
            )),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${teams[selectedTeamIndex].name} ',
                  style: TextStyles.title1,
                ),
                Transform.rotate(
                  angle: pi / 2,
                  child: const Icon(Icons.chevron_right_rounded),
                ),
              ],
            ),
          ),
          child: _RosterContent(
            team: teams[selectedTeamIndex],
            rosterModel: rosterModel,
          ),
        );
      },
    );
  }
}

class _RosterContent extends StatelessWidget {
  final Team team;
  final RosterModel rosterModel;

  const _RosterContent({
    required this.team,
    required this.rosterModel,
    Key? key,
  }) : super(key: key);

  int alphabeticalSort(a, b) => a.firstName.compareTo(b.firstName);

  @override
  Widget build(BuildContext context) {
    final List<Player> players = [
      for (String id in team.playerIDs) rosterModel.getPlayer(id)!
    ];

    if (team.playerIDs.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Roster', style: TextStyles.h1),
          Expanded(
            child: Center(
              child: Text(
                'No players in ${team.name}',
              ),
            ),
          ),
        ],
      );
    }

    final Widget heading = Row(
      children: [
        const Text('Roster', style: TextStyles.h1),
        const Spacer(),
        OptionButton(onTap: () => {}, icon: Icons.sort_rounded),
        const SizedBox(width: Insets.med),
        OptionButton(onTap: () {}, icon: Icons.filter_alt_rounded),
      ],
    );

    final sortedPlayers = players..sort(alphabeticalSort);

    return ListView(
      children: [
        heading,
        ...sortedPlayers
            .map<Widget>((player) => PlayerPreviewCard(player))
            //TODO: used divider
            .separate(const Divider(height: 0.5, thickness: 0.5))
            .toList(),
      ],
    );
  }
}

enum SortingStrategy {
  firstName,
  lastName,
  weight,
  gender,
  sidePreference,
  ageGroup,
}
