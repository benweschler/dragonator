import 'package:dragonator/data/paddler/paddler.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/router.dart';
import 'package:dragonator/screens/lineups/common/constants.dart';
import 'package:dragonator/screens/lineups/common/paddler_tile.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/navigator_utils.dart';
import 'package:dragonator/widgets/buttons/custom_back_button.dart';
import 'package:dragonator/widgets/buttons/custom_icon_button.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:dragonator/widgets/modal_sheets/context_menu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'common/boat_segment_builder.dart';

class LineupScreen extends StatelessWidget {
  final String lineupID;

  const LineupScreen({super.key, required this.lineupID});

  @override
  Widget build(BuildContext context) {
    final rosterModel = context.watch<RosterModel>();
    final lineup = rosterModel.getLineup(lineupID)!;

    final List<Paddler?> paddlerList =
        lineup.paddlerIDs.map((id) => rosterModel.getPaddler(id)).toList();

    return CustomScaffold(
      addScreenInset: false,
      leading: const CustomBackButton(),
      center: Text(lineup.name, style: TextStyles.title1),
      trailing: CustomIconButton(
        onTap: () => context.showModal(ContextMenu([
          ContextMenuAction(
            icon: Icons.edit_rounded,
            onTap: () => context.push(RoutePaths.nameLineup(lineupID)),
            label: 'Rename',
          ),
          ContextMenuAction(
            icon: Icons.view_list_rounded,
            onTap: () => context.go(RoutePaths.editLineup(lineupID)),
            label: 'Edit',
          ),
          ContextMenuAction(
            icon: Icons.delete_rounded,
            onTap: () {},
            label: 'Delete',
          ),
        ])),
        icon: Icons.more_horiz,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Insets.med),
          child: SizedBox(
            height: kGridRowHeight * (paddlerList.length / 2 + 1),
            child: Stack(
              children: [
                Column(
                  children: [
                    for (int i = 0; i < kBoatCapacity / 2 + 1; i++)
                      boatSegmentBuilder(context, i),
                  ],
                ),
                CustomMultiChildLayout(
                  delegate: _TileLayoutDelegate(paddlers: paddlerList),
                  children: [
                    for (int i = 0; i < paddlerList.length; i++)
                      LayoutId(
                        id: i,
                        child: paddlerList[i] != null
                            ? GestureDetector(
                                onTap: () => context.push(RoutePaths.paddler(
                                  paddlerList[i]!.id,
                                )),
                                child: PaddlerTile(paddlerList[i]!),
                              )
                            : const _EmptyPaddlerTile(),
                      )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TileLayoutDelegate extends MultiChildLayoutDelegate {
  final List<Paddler?> paddlers;

  _TileLayoutDelegate({required this.paddlers});

  @override
  void performLayout(Size parentSize) {
    for (int i = 0; i < paddlers.length; i++) {
      final tileSize = layoutChild(i, BoxConstraints.loose(parentSize));
      final row = (i / 2).ceil();
      final yPos = (row + 1 / 2) * kGridRowHeight - tileSize.height / 2;
      final double xPos;

      // Position drummer and steers person in the middle of their row.
      if (i == 0 || i == paddlers.length - 1) {
        xPos = parentSize.width / 2 - tileSize.width / 2;
      } else {
        xPos =
            parentSize.width * (i % 2 != 0 ? 0.25 : 0.75) - tileSize.width / 2;
      }

      positionChild(i, Offset(xPos, yPos));
    }
  }

  @override
  bool shouldRelayout(_TileLayoutDelegate oldDelegate) =>
      paddlers != oldDelegate.paddlers;
}

class _EmptyPaddlerTile extends StatelessWidget {
  const _EmptyPaddlerTile();

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Text(
        'Empty',
        style: TextStyles.body1.copyWith(
          color: AppColors.of(context).primary,
        ),
        maxLines: 2,
      ),
    );
  }
}
