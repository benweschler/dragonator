import 'package:dragonator/data/lineup/lineup.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/router.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LineupPreviewTile extends StatelessWidget {
  final Lineup lineup;
  final Future<void> Function()? onTap;

  const LineupPreviewTile(this.lineup, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final router = GoRouter.of(context);
        await onTap?.call();
        router.go(RoutePaths.lineup(lineup.id));
      },
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
    final rosterModel = context.read<RosterModel>();
    final paddlerNames = paddlerIDs.isEmpty
        ? 'No paddlers'
        : paddlerIDs.map((id) {
      final paddler = rosterModel.getPaddler(id);
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
              SizedBox(height: Insets.xs),
              Text(
                paddlerNames,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.body2.copyWith(
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
