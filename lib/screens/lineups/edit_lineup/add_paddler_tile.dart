import 'package:dragonator/data/paddler/paddler.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/router.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AddPaddlerTile extends StatelessWidget {
  /// The list of paddlers in the current state of the edited lineup.
  final List<Paddler?> editedLineupPaddlers;
  final ValueChanged<Paddler?> addPaddler;

  const AddPaddlerTile({
    super.key,
    required this.editedLineupPaddlers,
    required this.addPaddler,
  });

  @override
  Widget build(BuildContext context) {
    final unassignedPaddlers = context
        .read<RosterModel>()
        .paddlers
        .toSet()
        .difference(editedLineupPaddlers.toSet())
        .toList();

    return GestureDetector(
      onTap: () => context.push(
        RoutePaths.addPaddlerToLineup(GoRouterState.of(context).uri.path),
        extra: {
          //TODO: don't pass add paddler. pop with Paddler? and add here
          'addPaddler': addPaddler,
          'unassignedPaddlers': unassignedPaddlers,
        },
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 0.4 * MediaQuery.of(context).size.width,
        ),
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: Color.alphaBlend(
            AppColors.of(context).primarySurface,
            AppColors.of(context).background,
          ),
          borderRadius: Corners.smBorderRadius,
          border: Border.all(color: AppColors.of(context).primary),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add',
              style: TextStyles.body1.copyWith(
                color: AppColors.of(context).primary,
              ),
              maxLines: 2,
            ),
            const SizedBox(width: Insets.xs),
            Icon(Icons.add_rounded, color: AppColors.of(context).primary),
          ],
        ),
      ),
    );
  }
}
