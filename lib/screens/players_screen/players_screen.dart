import 'dart:math';

import 'package:dragonator/data/team.dart';
import 'package:dragonator/dummy_data.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:dragonator/utils/navigator_utils.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:dragonator/widgets/modal_sheets/context_menu.dart';
import 'package:flutter/material.dart';

import 'components/player_card.dart';

class PlayersScreen extends StatelessWidget {
  final ValueNotifier<Team> selectedTeamNotifier = ValueNotifier(teamOne);

  PlayersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedTeamNotifier,
      builder: (_, team, __) {
        return CustomScaffold(
          center: ResponsiveStrokeButton(
            onTap: () => context.showModal(
              ContextMenu(
                actions: [
                  ContextMenuAction(
                    icon: Icons.abc,
                    label: "Team One",
                    onTap: () {
                      if (selectedTeamNotifier.value != teamOne) {
                        selectedTeamNotifier.value = teamOne;
                      }
                    },
                  ),
                  ContextMenuAction(
                    icon: Icons.abc,
                    label: "Team Two",
                    onTap: () {
                      if (selectedTeamNotifier.value != teamTwo) {
                        selectedTeamNotifier.value = teamTwo;
                      }
                    },
                  ),
                ],
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${team.name} ",
                  style: TextStyles.title1,
                ),
                Transform.rotate(
                  angle: pi / 2,
                  child: const Icon(Icons.chevron_right_sharp),
                ),
              ],
            ),
          ),
          child: _RosterContent(team),
        );
      },
    );
  }
}

class _RosterContent extends StatelessWidget {
  final Team team;

  const _RosterContent(this.team, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (team.roster.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Roster", style: TextStyles.h1),
          Expanded(
            child: Center(
              child: Text(
                "No players in ${team.name}",
              ),
            ),
          ),
        ],
      );
    }

    return ListView(
      children: [
        const Text("Roster", style: TextStyles.h1),
        ...team.roster
            .map<Widget>((player) => PlayerCard(player))
            //TODO: don't hardcode, this sucks
            .separate(const Divider(height: 0.5, thickness: 0.5))
            .toList(),
      ],
    );
  }
}
