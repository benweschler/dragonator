import 'package:dragonator/data/boat/boat.dart';
import 'package:dragonator/data/lineup/lineup.dart';
import 'package:dragonator/data/paddler/paddler.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/models/settings_model.dart';
import 'package:dragonator/router.dart';
import 'package:dragonator/screens/lineups/common/constants.dart';
import 'package:dragonator/screens/lineups/common/paddler_tile.dart';
import 'package:dragonator/screens/paddler_popup/paddler_popup.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/dependence_mixins/team_detail_dependent_state_mixin.dart';
import 'package:dragonator/utils/navigation_utils.dart';
import 'package:dragonator/widgets/buttons/custom_back_button.dart';
import 'package:dragonator/widgets/buttons/custom_icon_button.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:dragonator/widgets/modal_sheets/context_menu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'common/boat_segment_builder.dart';
import 'common/com.dart';

class LineupScreen extends StatefulWidget {
  final String lineupID;

  const LineupScreen({super.key, required this.lineupID});

  @override
  State<LineupScreen> createState() => _LineupScreenState();
}

class _LineupScreenState extends State<LineupScreen>
    with TeamDetailDependentStateMixin {
  @override
  Widget build(BuildContext context) {
    return Selector<RosterModel, (Lineup?, Boat?, List<Paddler?>?)>(
      shouldRebuild: (previous, next) => next.$1 != null,
      selector: (context, model) {
        final lineup = model.getLineup(widget.lineupID);

        return (
          model.getLineup(widget.lineupID),
          model.currentTeam!.boats[lineup?.boatID],
          lineup?.paddlerIDs.map((id) => model.getPaddler(id)).toList()
        );
      },
      builder: (context, data, _) {
        final (lineup, boat, paddlerList) = (data.$1!, data.$2!, data.$3!);
        const verticalInset = Insets.med;

        return CustomScaffold(
          addScreenInset: false,
          leading: const CustomBackButton(),
          center: Text(lineup.name, style: TextStyles.title1),
          trailing: CustomIconButton(
            onTap: () => context.showModal(Selector<SettingsModel, bool>(
              selector: (_, model) => model.showComOverlay,
              builder: (context, showingCOM, _) => ContextMenu([
                ContextMenuAction(
                  icon: Icons.edit_rounded,
                  onTap: () => context.push(
                    RoutePaths.nameLineup(widget.lineupID),
                  ),
                  label: 'Rename',
                ),
                ContextMenuAction(
                  icon: Icons.view_list_rounded,
                  onTap: () => context.go(
                    RoutePaths.editLineup(widget.lineupID),
                  ),
                  label: 'Edit',
                ),
                ContextMenuAction(
                  onTap: () => context
                      .read<SettingsModel>()
                      .setShowComOverlay(!showingCOM),
                  icon: showingCOM ? Icons.hide_source : Icons.circle_outlined,
                  label: '${showingCOM ? 'Hide' : 'Show'} Center of Mass',
                ),
                ContextMenuAction(
                  icon: Icons.delete_rounded,
                  onTap: () {
                    cancelDetailDependence();
                    context.read<RosterModel>().deleteLineup(widget.lineupID);
                    context.pop();
                  },
                  isDestructiveAction: true,
                  label: 'Delete',
                ),
              ]),
            )),
            icon: Icons.more_horiz,
          ),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: verticalInset),
                  child: SizedBox(
                    height: kGridRowHeight * (paddlerList.length / 2 + 1),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            for (int i = 0; i < boat.capacity / 2 + 1; i++)
                              boatSegmentBuilder(context, i, boat.capacity),
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
                                        onTap: () => context.showPopup(
                                          PaddlerPopup(paddlerList[i]!.id),
                                        ),
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
                Positioned.fill(
                  child: IgnorePointer(
                    child: Selector<SettingsModel, bool>(
                      selector: (_, model) => model.showComOverlay,
                      builder: (_, visible, child) => Visibility(
                        visible: visible,
                        child: child!,
                      ),
                      child: COMOverlay(
                        duration: const Duration(milliseconds: 250),
                        com: calculateCOM(boat: boat, paddlerList: paddlerList),
                        topInset: verticalInset,
                        bottomInset: verticalInset,
                        leftAlignment: 0.25,
                        rightAlignment: 0.75,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  String get detailLabel => 'lineup';

  @override
  Object? Function() get getDetail =>
      () => context.read<RosterModel>().getLineup(widget.lineupID);

  @override
  VoidCallback get dismissWidget => context.popToRoot;
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
