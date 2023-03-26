import 'dart:math';

import 'package:dragonator/data/player.dart';
import 'package:dragonator/data/team.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/router.dart';
import 'package:dragonator/screens/roster_screen/sorting_options_menu.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:dragonator/utils/navigator_utils.dart';
import 'package:dragonator/utils/player_sorting.dart';
import 'package:dragonator/widgets/buttons/chip_button.dart';
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

        final changeTeamButton = ResponsiveStrokeButton(
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
        );

        return CustomScaffold(
          addScreenInset: false,
          floatingActionButton: CustomFAB(
            child: const Icon(Icons.add_rounded),
            onTap: () => context.go(RoutePaths.editPlayer(
              teamID: teams[selectedTeamIndex].id,
            )),
          ),
          center: changeTeamButton,
          child: teams[selectedTeamIndex].playerIDs.isEmpty
              ? _EmptyRoster(teamName: teams[selectedTeamIndex].name)
              : _RosterContent(
                  team: teams[selectedTeamIndex],
                  rosterModel: rosterModel,
                ),
        );
      },
    );
  }
}

//TODO: naming of state variables needs to be improved
//TODO: state management should be moved to a provider
class _RosterContent extends StatefulWidget {
  final Team team;
  final RosterModel rosterModel;

  const _RosterContent({
    required this.team,
    required this.rosterModel,
    Key? key,
  }) : super(key: key);

  @override
  State<_RosterContent> createState() => _RosterContentState();
}

class _RosterContentState extends State<_RosterContent> {
  var sortingStrategy = PlayerSort.sortingStrategyLabels.keys.first;
  bool sortIncreasing = true;

  @override
  Widget build(BuildContext context) {
    final List<Player> players = [
      for (String id in widget.team.playerIDs) widget.rosterModel.getPlayer(id)!
    ];

    final Widget filterRow = SingleChildScrollView(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: <Widget>[
          ChipButton(
            isActive: true,
            onTap: () => context.showModal(SortingOptionsMenu(
              sortingStrategies: PlayerSort.sortingStrategyLabels.keys,
              initiallySelectedStrategy: sortingStrategy,
              sortIncreasing: sortIncreasing,
              onSave: (newStrategy, isIncreasing) => setState(() {
                sortingStrategy = newStrategy;
                sortIncreasing = isIncreasing;
              }),
            )),
            child: Row(
              children: const [
                Icon(Icons.sort_rounded),
                SizedBox(width: Insets.xs),
                Text('Sort'),
              ],
            ),
          ),
          for(String label in ['Gender', 'Side Preference', 'Age Group'])
            ChipButton(
              onTap: () {},
              child: Row(
                children: [
                  Text(label),
                  const SizedBox(width: Insets.xs),
                  Transform.rotate(
                    angle: pi / 2,
                    child: const Icon(Icons.chevron_right_rounded),
                  ),
                ],
              ),
            ),
        ].separate(const SizedBox(width: Insets.sm)).toList(),
      ),
    );

    Iterable<Player> sortedPlayers = players
      ..sort(PlayerSort.sortingStrategyLabels[sortingStrategy]);

    if (!sortIncreasing) {
      sortedPlayers = players.reversed;
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: Insets.offset),
      children: [
        const Text('Roster', style: TextStyles.h1),
        const SizedBox(height: Insets.xs),
        filterRow,
        const SizedBox(height: Insets.sm),
        ...sortedPlayers
            .map<Widget>((player) => PlayerPreviewCard(player))
            //TODO: used divider
            .separate(const Divider(height: 0.5, thickness: 0.5))
            .toList(),
      ],
    );
  }
}

class _EmptyRoster extends StatelessWidget {
  final String teamName;

  const _EmptyRoster({Key? key, required this.teamName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.offset),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Roster', style: TextStyles.h1),
          Expanded(
            child: Center(
              child: Text(
                'No players in $teamName',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
