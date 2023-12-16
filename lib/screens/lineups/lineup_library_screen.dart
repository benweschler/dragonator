import 'package:dragonator/data/lineup.dart';
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

class LineupLibraryScreen extends StatefulWidget {
  const LineupLibraryScreen({super.key});

  @override
  State<LineupLibraryScreen> createState() => _LineupLibraryScreenState();
}

class _LineupLibraryScreenState extends State<LineupLibraryScreen> {
  int selectedTeamIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<RosterModel>(
      builder: (_, rosterModel, __) => CustomScaffold(
        center: ChangeTeamHeading(
          teams: rosterModel.teams.toList(),
          selectedTeamIndex: selectedTeamIndex,
          updateSelectedTeamIndex: (newIndex) =>
              setState(() => selectedTeamIndex = newIndex),
        ),
        floatingActionButton: Builder(builder: (context) {
          return CustomFAB(
            onTap: () => context.push(RoutePaths.nameLineup()),
            child: const Icon(Icons.add_rounded),
          );
        }),
        child: ListView(
          children: [
            const Text('Lineups', style: TextStyles.h1),
            const SizedBox(height: Insets.sm),
            ...context
                .read<RosterModel>()
                .lineups
                .map<Widget>((lineup) => LineupPreviewTile(lineup))
                .separate(const Divider(height: 0.5, thickness: 0.5)),
          ],
        ),
      ),
    );
  }
}

class LineupPreviewTile extends StatelessWidget {
  final Lineup lineup;

  const LineupPreviewTile(this.lineup, {super.key});

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
        child: _buildContent(AppColors.of(context)),
      ),
    );
  }

  Widget _buildContent(AppColors appColors) {
    final paddlerNames = lineup.paddlers.isEmpty
        ? 'No paddlers'
        : lineup.paddlers
            .where((paddler) => paddler != null)
            .map((paddler) => '${paddler!.firstName} ${paddler.lastName}')
            .join(', ');

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lineup.name,
                style: TextStyles.title1.copyWith(color: appColors.accent),
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
