import 'dart:io';

import 'package:animated_reorderable_grid/animated_reorderable_grid.dart';
import 'package:defer_pointer/defer_pointer.dart';
import 'package:dragonator/data/paddler.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/router.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/navigator_utils.dart';
import 'package:dragonator/widgets/modal_sheets/context_menu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PaddlerGridTile extends StatelessWidget {
  final String paddlerID;
  final int index;
  final VoidCallback removePaddler;

  const PaddlerGridTile({
    super.key,
    required this.paddlerID,
    required this.index,
    required this.removePaddler,
  });

  @override
  Widget build(BuildContext context) {
    final paddler = context
        .select<RosterModel, Paddler>((model) => model.getPaddler(paddlerID)!);

    final tileBody = Container(
      constraints: BoxConstraints(
        maxWidth: 0.4 * MediaQuery.of(context).size.width,
      ),
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        borderRadius: Corners.smBorderRadius,
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(
          color: AppColors.of(context).primaryContainer,
        ),
      ),
      child: Text(
        '${paddler.firstName} ${paddler.lastName}',
        style: TextStyles.body1.copyWith(
          color: AppColors.of(context).primaryContainer,
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );

    return DeferredPointerHandler(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ReorderableGridDragListener(
            index: index,
            child: tileBody,
          ),
          Positioned(
            right: -13,
            top: -13,
            child: DeferPointer(
              child: _PaddlerOptionsButton(
                showPaddlerContextMenu: () => context.showModal(
                  _PaddlerContextMenu(
                    paddlerID: paddlerID,
                    removePaddler: removePaddler,
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

    return GestureDetector(
      onTap: showPaddlerContextMenu,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.of(context).neutralContent,
          ),
          color: Color.alphaBlend(
            AppColors.of(context).smallSurface,
            Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
        child: Icon(
          moreIcon,
          size: 18,
          color: AppColors.of(context).neutralContent,
        ),
      ),
    );
  }
}

class _PaddlerContextMenu extends StatelessWidget {
  final String paddlerID;
  final VoidCallback removePaddler;

  const _PaddlerContextMenu({
    required this.paddlerID,
    required this.removePaddler,
  });

  @override
  Widget build(BuildContext context) {
    return ContextMenu([
      ContextMenuAction(
        icon: Icons.info_outline_rounded,
        onTap: () => context.push(RoutePaths.paddler(paddlerID)),
        label: 'Information',
      ),
      ContextMenuAction(
        icon: Icons.delete,
        onTap: removePaddler,
        label: 'Remove',
      ),
    ]);
  }
}
