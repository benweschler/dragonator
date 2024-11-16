import 'package:dragonator/data/paddler.dart';
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
import 'package:dragonator/widgets/paddler_preview_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RosterScreen extends StatelessWidget {
  const RosterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RosterModel>(
      builder: (context, rosterModel, _) {
        final teams = rosterModel.teams.toList();
        final hasPaddlers = rosterModel.paddlers.isNotEmpty;
        final appBarCenter = teams.isNotEmpty ? ChangeTeamHeading() : null;

        //TODO: implement screen if user has no teams.
        final content = teams.isNotEmpty && hasPaddlers
            ? _RosterContent(
                paddlerIDs: rosterModel.paddlerIDs,
                rosterModel: rosterModel,
              )
            : _EmptyRoster(
                content: hasPaddlers
                    //TODO: this will throw index out of bounds if teams is empty
                    ? 'No paddlers in ${rosterModel.currentTeam!.name}'
                    : 'You haven\'t created any teams yet. Head to settings to create your first team.',
              );

        return CustomScaffold(
          addScreenInset: false,
          floatingActionButton: CustomFAB(
            child: const Icon(Icons.add_rounded),
            //TODO: verify change from go to psh
            onTap: () => context.push(RoutePaths.editPaddler()),
          ),
          center: appBarCenter,
          child: content,
        );
      },
    );
  }
}

class _RosterContent extends StatefulWidget {
  final Iterable<String> paddlerIDs;
  final RosterModel rosterModel;

  const _RosterContent({
    required this.paddlerIDs,
    required this.rosterModel,
  });

  @override
  State<_RosterContent> createState() => _RosterContentState();
}

class _RosterContentState extends State<_RosterContent> {
  String sortingStrategy = PaddlerSort.sortingStrategyLabels.keys.first;
  bool sortIncreasing = true;
  Gender? genderFilter;
  SidePreference? sidePreferenceFilter;
  AgeGroup? ageGroupFilter;

  @override
  Widget build(BuildContext context) {
    final List<Paddler> paddlers = [
      for (String id in widget.paddlerIDs) widget.rosterModel.getPaddler(id)!
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

  const _EmptyRoster({required this.content});

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
