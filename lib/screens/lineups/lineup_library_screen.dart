import 'package:dragonator/data/lineup/lineup.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/router.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:dragonator/widgets/buttons/custom_fab.dart';
import 'package:dragonator/widgets/change_team_heading.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

//TODO: lineups are broken when a paddler is deleted.

class LineupLibraryScreen extends StatelessWidget {
  const LineupLibraryScreen({super.key});

  //TODO: add screen if user has no lineups
  //TODO: add screen if user has no teams

  @override
  Widget build(BuildContext context) {
    return Consumer<RosterModel>(
      builder: (_, rosterModel, __) {
        final Widget content;
        if (rosterModel.lineups.isEmpty) {
          content = Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  rosterModel.currentTeam != null
                      ? '${rosterModel.currentTeam!.name} doesn\'t have any lineups yet.'
                      //TODO: navigate to creating a team if there are no teams
                      : 'You haven\'t created any teams yet. Head to settings to create your first team.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        } else {
          // Sort lineups alphabetically
          final sortedLineups = rosterModel.lineups.toList()
            ..sort((a, b) => a.name.compareTo(b.name));

          content = ListView(
            children: [
              const Text('Lineups', style: TextStyles.h1),
              const SizedBox(height: Insets.sm),
              ...sortedLineups
                  .map<Widget>((lineup) => _LineupPreviewTile(lineup))
                  .separate(const Divider(height: 0.5, thickness: 0.5)),
            ],
          );
        }

        return CustomScaffold(
          center: ChangeTeamHeading(),
          floatingActionButton: Builder(builder: (context) {
            return CustomFAB(
              onTap: () => context.push(RoutePaths.nameLineup()),
              child: const Icon(Icons.add_rounded),
            );
          }),
          child: content,
        );
      },
    );
  }
}

class _LineupPreviewTile extends StatelessWidget {
  final Lineup lineup;

  const _LineupPreviewTile(this.lineup);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(RoutePaths.lineup(lineup.id)),
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Insets.sm,
          vertical: Insets.med,
        ),
        child: _buildContent(AppColors.of(context), context),
      ),
    );
  }

  Widget _buildContent(AppColors appColors, BuildContext context) {
    final paddlerIDs = lineup.paddlerIDs.where((id) => id != null);

    final paddlerNames = paddlerIDs.isEmpty
        ? 'No paddlers'
        : paddlerIDs.map((id) {
            final paddler = context.read<RosterModel>().getPaddler(id);
            return '${paddler!.firstName} ${paddler.lastName}';
          }).join(', ');

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lineup.name,
                style: TextStyles.title1.copyWith(color: appColors.primary),
              ),
              Text(
                paddlerNames,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.caption.copyWith(
                  color: appColors.neutralContent,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.chevron_right_rounded,
          color: appColors.neutralContent,
        ),
      ],
    );
  }
}
