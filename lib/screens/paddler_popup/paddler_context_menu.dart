import 'package:dragonator/data/paddler/paddler.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/router.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/utils/navigation_utils.dart';
import 'package:dragonator/widgets/modal_sheets/context_menu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'copy_to_team_menu.dart';

class PaddlerContextMenu extends StatelessWidget {
  final Paddler paddler;
  final BuildContext popupContext;

  const PaddlerContextMenu({
    super.key,
    required this.paddler,
    required this.popupContext,
  });

  @override
  Widget build(BuildContext context) {
    return ContextMenu([
      ContextMenuAction(
        onTap: () async {
          await Future.delayed(Timings.long);

          if (!popupContext.mounted) return;
          popupContext.push(RoutePaths.editPaddler(paddlerID: paddler.id));
        },
        icon: Icons.edit_rounded,
        label: 'Edit',
      ),
      ContextMenuAction(
        onTap: () async {
          await Future.delayed(Timings.long);

          if (!popupContext.mounted) return;
          popupContext.showModal(CopyPaddlerToTeamMenu(
            paddler: paddler,
            popupContext: popupContext,
          ));
        },
        icon: Icons.add_rounded,
        label: 'Add to team',
      ),
      ContextMenuAction(
        onTap: () => Navigator.of(popupContext).pushNamed('/lineups'),
        icon: Icons.library_books,
        label: 'View lineups',
      ),
      ContextMenuAction(
        onTap: () async {
          await context.read<RosterModel>().deletePaddler(paddler.id);
          if (context.mounted) context.pop();
        },
        isDestructiveAction: true,
        icon: Icons.delete_rounded,
        label: 'Delete',
      ),
    ]);
  }
}
