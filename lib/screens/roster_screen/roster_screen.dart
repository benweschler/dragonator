import 'dart:math';

import 'package:dragonator/data/paddler.dart';
import 'package:dragonator/data/team.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/router.dart';
import 'package:dragonator/screens/roster_screen/sorting_options_menu.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:dragonator/utils/navigator_utils.dart';
import 'package:dragonator/utils/paddler_sorting.dart';
import 'package:dragonator/widgets/buttons/chip_button.dart';
import 'package:dragonator/widgets/buttons/custom_filter_chip.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:dragonator/widgets/buttons/custom_fab.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:dragonator/widgets/modal_sheets/selection_menu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'paddler_preview_card.dart';

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
            onTap: () => context.go(RoutePaths.editPaddler(
              teamID: teams[selectedTeamIndex].id,
            )),
          ),
          center: changeTeamButton,
          child: teams[selectedTeamIndex].paddlerIDs.isEmpty
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
  var sortingStrategy = PaddlerSort.sortingStrategyLabels.keys.first;
  bool sortIncreasing = true;

  @override
  Widget build(BuildContext context) {
    final List<Paddler> paddlers = [
      for (String id in widget.team.paddlerIDs) widget.rosterModel.getPaddler(id)!
    ];

    final Widget filterRow = SingleChildScrollView(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: <Widget>[
          ChipButton(
            fillColor: AppColors.of(context).accent,
            contentColor: Colors.white,
            onTap: () => context.showModal(SortingOptionsMenu(
              sortingStrategies: PaddlerSort.sortingStrategyLabels.keys,
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
          for (String label in ['Gender', 'Side', 'Age Group'])
            CustomFilterChip<Gender>(
              label: label,
              onFiltered: (_) {},
              options: Gender.values,
            ),
        ].separate(const SizedBox(width: Insets.sm)).toList(),
      ),
    );

    Iterable<Paddler> sortedPaddlers = paddlers
      ..sort(PaddlerSort.sortingStrategyLabels[sortingStrategy]);

    if (!sortIncreasing) {
      sortedPaddlers = paddlers.reversed;
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: Insets.offset),
      children: [
        const Text('Roster', style: TextStyles.h1),
        const SizedBox(height: Insets.xs),
        filterRow,
        const SizedBox(height: Insets.sm),
        ...sortedPaddlers
            .map<Widget>((paddler) => PaddlerPreviewCard(paddler))
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
                'No paddlers in $teamName',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
