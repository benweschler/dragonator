import 'dart:math';

import 'package:dragonator/data/player.dart';
import 'package:dragonator/data/team.dart';
import 'package:dragonator/dummy_data.dart' as dummy_data;
import 'package:dragonator/router.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:dragonator/utils/navigator_utils.dart';
import 'package:dragonator/widgets/buttons/option_button.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:dragonator/widgets/custom_fab.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:dragonator/widgets/modal_sheets/selection_menu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'player_preview_card.dart';

class RosterScreen extends StatelessWidget {
  final List<Team> teams;
  late final ValueNotifier<int> selectedTeamIndexNotifier = ValueNotifier(0);

  RosterScreen({Key? key})
      : teams = dummy_data.teams,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedTeamIndexNotifier,
      builder: (_, team, __) {
        return CustomScaffold(
          floatingActionButton: CustomFAB(
            color: Colors.black,
            child: const Icon(Icons.add_rounded, color: Colors.white),
            onTap: () => context.push(RoutePaths.editPlayer()),
          ),
          center: ResponsiveStrokeButton(
            onTap: () => context.showModal(SelectionMenu(
              items: teams.map((team) => team.name).toList(),
              initiallySelectedIndex: selectedTeamIndexNotifier.value,
              onItemTap: (newTeamIndex) {
                if (selectedTeamIndexNotifier.value != newTeamIndex) {
                  selectedTeamIndexNotifier.value = newTeamIndex;
                }
              },
            )),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${teams[selectedTeamIndexNotifier.value].name} ",
                  style: TextStyles.title1,
                ),
                Transform.rotate(
                  angle: pi / 2,
                  child: const Icon(Icons.chevron_right_rounded),
                ),
              ],
            ),
          ),
          child: _RosterContent(teams[selectedTeamIndexNotifier.value]),
        );
      },
    );
  }
}

class _RosterContent extends StatelessWidget {
  final Team team;
  final Map<String, Player> playerIDMap;

  _RosterContent(this.team, {Key? key})
      : playerIDMap = dummy_data.playerIDMap,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (team.playerIDs.isEmpty) {
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

    final Widget heading = Row(
      children: [
        const Text("Roster", style: TextStyles.h1),
        const Spacer(),
        OptionButton(onTap: () => {}, icon: Icons.sort_rounded),
        const SizedBox(width: Insets.med),
        OptionButton(onTap: () {}, icon: Icons.filter_alt_rounded),
      ],
    );

    final sortedIDs = team.playerIDs.toList()
      ..sort((a, b) =>
          playerIDMap[a]!.firstName.compareTo(playerIDMap[b]!.firstName));

    return ListView(
      children: [
        heading,
        ...sortedIDs
            .map<Widget>((id) => PlayerPreviewCard(playerIDMap[id]!))
            //TODO: don't hardcode, this sucks
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
