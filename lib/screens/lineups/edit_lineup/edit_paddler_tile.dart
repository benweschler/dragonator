import 'dart:io';

import 'package:animated_reorderable_grid/animated_reorderable_grid.dart';
import 'package:defer_pointer/defer_pointer.dart';
import 'package:dragonator/data/paddler/paddler.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/screens/lineups/common/paddler_tile.dart';
import 'package:dragonator/screens/paddler_popup/paddler_popup.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/navigation_utils.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:dragonator/widgets/modal_sheets/context_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditPaddlerTile extends StatelessWidget {
  final String paddlerID;
  final int index;
  final VoidCallback removePaddler;

  const EditPaddlerTile({
    super.key,
    required this.paddlerID,
    required this.index,
    required this.removePaddler,
  });

  @override
  Widget build(BuildContext context) {
    return DeferredPointerHandler(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ReorderableGridDragListener(
            index: index,
            child: Selector<RosterModel, Paddler?>(
              selector: (context, model) => model.getPaddler(paddlerID),
              shouldRebuild: (_, newPaddler) => newPaddler != null,
              builder: (context, paddler, _) => PaddlerTile(paddler!),
            ),
          ),
          Positioned(
            // The radius of the paddler options button is 13.
            right: -13,
            top: -13,
            child: DeferPointer(
              child: _PaddlerOptionsButton(
                showPaddlerContextMenu: () => context.showModal(
                  _PaddlerContextMenu(
                    paddlerID: paddlerID,
                    removePaddler: removePaddler,
                    popupContext: context,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaddlerOptionsButton extends StatelessWidget {
  final VoidCallback showPaddlerContextMenu;

  const _PaddlerOptionsButton({required this.showPaddlerContextMenu});

  @override
  Widget build(BuildContext context) {
    final moreIcon = Platform.isAndroid ? Icons.more_vert : Icons.more_horiz;

    return ResponsiveButton(
      onTap: showPaddlerContextMenu,
      builder: (overlay) => Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          color: Color.alphaBlend(
            AppColors.of(context).smallSurface,
            AppColors.of(context).background,
          ),
        ),
        child: Icon(
          moreIcon,
          size: 18,
          color: Color.alphaBlend(
            overlay,
            AppColors.of(context).neutralContent,
          ),
        ),
      ),
    );
  }
}

class _PaddlerContextMenu extends StatelessWidget {
  final String paddlerID;
  final VoidCallback removePaddler;
  final BuildContext popupContext;

  const _PaddlerContextMenu({
    required this.paddlerID,
    required this.removePaddler,
    required this.popupContext,
  });

  @override
  Widget build(BuildContext context) {
    return ContextMenu([
      ContextMenuAction(
        icon: Icons.info_outline_rounded,
        onTap: () async {
          await Future.delayed(Timings.long);
          if (popupContext.mounted) {
            popupContext.showPopup(PaddlerPopup(paddlerID));
          }
        },
        label: 'Information',
      ),
      ContextMenuAction(
        icon: Icons.delete,
        onTap: removePaddler,
        isDestructiveAction: true,
        label: 'Remove',
      ),
    ]);
  }
}
