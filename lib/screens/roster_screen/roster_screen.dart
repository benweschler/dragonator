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
import 'package:dragonator/widgets/buttons/custom_fab.dart';
import 'package:dragonator/widgets/change_team_heading.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'paddler_preview_tile.dart';

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

        final hasPaddlers = teams.isNotEmpty
            ? teams[selectedTeamIndex].paddlerIDs.isNotEmpty
            : false;

        final appBarCenter = teams.isNotEmpty
            ? ChangeTeamHeading(
                teams: teams,
                selectedTeamIndex: selectedTeamIndex,
                updateSelectedTeamIndex: (newTeamIndex) =>
                    setState(() => selectedTeamIndex = newTeamIndex),
              )
            : null;

        final content = teams.isNotEmpty && hasPaddlers
            ? _RosterContent(
                team: teams[selectedTeamIndex],
                rosterModel: rosterModel,
              )
            : _EmptyRoster(
                content: hasPaddlers
                    ? 'No paddlers in ${teams[selectedTeamIndex].name}'
                    : 'You haven\'t created any teams yet. Head to settings to create your first team.',
              );

        return CustomScaffold(
          addScreenInset: false,
          floatingActionButton: CustomFAB(
            child: const Icon(Icons.add_rounded),
            onTap: () => context.go(RoutePaths.editPaddler(
              teamID: teams[selectedTeamIndex].id,
            )),
          ),
          center: appBarCenter,
          child: content,
        );
      },
    );
  }
}

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
  Gender? genderFilter;
  SidePreference? sidePreferenceFilter;
  AgeGroup? ageGroupFilter;

  @override
  Widget build(BuildContext context) {
    final List<Paddler> paddlers = [
      for (String id in widget.team.paddlerIDs)
        widget.rosterModel.getPaddler(id)!
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
            child: const Row(
              children: [
                Icon(Icons.sort_rounded),
                SizedBox(width: Insets.xs),
                Text('Sort'),
              ],
            ),
          ),
          CustomFilterChip<Gender>(
            label: 'Gender',
            onFiltered: (gender) => setState(() => genderFilter = gender),
            options: Gender.values,
          ),
          CustomFilterChip<SidePreference>(
            label: 'Side',
            onFiltered: (sidePreference) =>
                setState(() => sidePreferenceFilter = sidePreference),
            options: SidePreference.values,
          ),
          CustomFilterChip<AgeGroup>(
            label: 'Age Group',
            onFiltered: (ageGroup) => setState(() => ageGroupFilter = ageGroup),
            options: AgeGroup.values,
          ),
        ].separate(const SizedBox(width: Insets.sm)).toList(),
      ),
    );

    List<Paddler> sortedPaddlers = paddlers.where((paddler) {
      if (genderFilter != null && paddler.gender != genderFilter) {
        return false;
      } else if (sidePreferenceFilter != null &&
          paddler.sidePreference != sidePreferenceFilter) {
        return false;
      } else if (ageGroupFilter != null && paddler.ageGroup != ageGroupFilter) {
        return false;
      }

      return true;
    }).toList()
      ..sort(PaddlerSort.sortingStrategyLabels[sortingStrategy]);

    if (!sortIncreasing) {
      sortedPaddlers = sortedPaddlers.reversed.toList();
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: Insets.offset),
      children: [
        const Text('Roster', style: TextStyles.h1),
        const SizedBox(height: Insets.xs),
        filterRow,
        const SizedBox(height: Insets.sm),
        if (sortedPaddlers.isNotEmpty)
          ...sortedPaddlers
              .map<Widget>((paddler) => PaddlerPreviewTile(paddler))
              //TODO: used divider
              .separate(const Divider(height: 0.5, thickness: 0.5))
              .toList()
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Insets.xl),
            child: Center(
              child: Text(
                'No matching paddlers',
                style: TextStyle(color: AppColors.of(context).neutralContent),
              ),
            ),
          ),
      ],
    );
  }
}

class _EmptyRoster extends StatelessWidget {
  final String content;

  const _EmptyRoster({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.offset),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Text(content, textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
    );
  }
}
