import 'package:dragonator/data/boat/boat.dart';
import 'package:dragonator/data/lineup/lineup.dart';
import 'package:dragonator/data/paddler/paddler.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/screens/lineups/common/boat_segment_builder.dart';
import 'package:dragonator/screens/lineups/common/com.dart';
import 'package:dragonator/screens/lineups/common/constants.dart';
import 'package:dragonator/screens/lineups/edit_lineup/add_paddler_tile.dart';
import 'package:dragonator/screens/lineups/edit_lineup/edit_lineup_options_modal_sheet.dart';
import 'package:dragonator/screens/lineups/edit_lineup/edit_paddler_tile.dart';
import 'package:dragonator/screens/lineups/edit_lineup/lineup_history.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/navigation_utils.dart';
import 'package:dragonator/models/settings_model.dart';
import 'package:dragonator/widgets/buttons/custom_fab.dart';
import 'package:dragonator/widgets/buttons/custom_icon_button.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:animated_reorderable_grid/animated_reorderable_grid.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'paddler_deleted_popup.dart';

//TODO: can't handle odd boat capacities
class EditLineupScreen extends StatefulWidget {
  final String lineupID;

  const EditLineupScreen({super.key, required this.lineupID});

  @override
  State<EditLineupScreen> createState() => _EditLineupScreenState();
}

class _EditLineupScreenState extends State<EditLineupScreen> {
  late final RosterModel _rosterModel;
  late final Lineup _lineup;
  late final LineupHistory _history;
  late Boat _boat;

  @override
  void initState() {
    super.initState();

    _rosterModel = context.read<RosterModel>();
    _lineup = _rosterModel.getLineup(widget.lineupID)!;
    _history = LineupHistory(
      initial:
          _lineup.paddlerIDs.map((id) => _rosterModel.getPaddler(id)).toList(),
    );
    _boat = _rosterModel.currentTeam!.boats[_lineup.boatID]!;
    _rosterModel.addListener(_checkPaddlerDeleted);
  }

  @override
  void dispose() {
    _rosterModel.removeListener(_checkPaddlerDeleted);
    super.dispose();
  }

  //TODO: paddler tile throws null check error when paddler is deleted before it is removed.
  // Remove paddlers from the editing list
  void _checkPaddlerDeleted() {
    final deletedPaddlerNames = <String>[];
    final paddlerList = _history.current;
    final rosterModel = context.read<RosterModel>();
    for (int i = 0; i < paddlerList.length; i++) {
      final paddler = paddlerList[i];
      if (paddler == null) continue;
      if (rosterModel.getPaddler(paddler.id) == null) {
        deletedPaddlerNames.add('${paddler.firstName} ${paddler.lastName}');
        paddlerList[i] = null;
      }
    }

    if (deletedPaddlerNames.isEmpty) return;
    _history.flush(paddlerList);
    context.showPopup(PaddlerDeletedPopup(deletedPaddlerNames));
  }

  Future<void> _saveLineup() {
    // TODO: could throw an error if one of these paddlers was deleted. Must check if paddlers are deleted. Maybe also check if lineup was deleted, renamed, i.e. other properties changed.
    return context.read<RosterModel>().setLineup(_lineup.copyWith(
          boatID: _boat.id,
          paddlerIDs: _history.current.map((paddler) => paddler?.id),
        ));
  }

  //TODO: changing to a larger boat causes an error
  void _changeLineupBoat(Boat boat) {
    setState(() {
      _boat = boat;
      _history.flush(List<Paddler?>.generate(
        boat.capacity,
        (index) => index < _history.paddlerLength ? _history.at(index) : null,
      ));
    });
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final paddler = _history.at(index);
    if (paddler != null) {
      return EditPaddlerTile(
        paddlerID: paddler.id,
        index: index,
        removePaddler: () => _history.set(index, null),
      );
    }

    return AddPaddlerTile(
      editedLineupPaddlers: _history.current,
      addPaddler: (paddler) {
        if (paddler == null) return;
        _history.set(index, paddler);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //TODO: gives wrong COM between lineup and edit lineup? check if moving here made a difference.
    const headerPadding = Insets.med;
    final footerPadding =
        Insets.med + MediaQuery.of(context).viewPadding.bottom;
    final comAnimationDuration = 250.ms;

    return Scaffold(
      appBar: CustomAppBar(
        leading: CustomIconButton(
          onTap: context.pop,
          icon: Icons.close_rounded,
        ),
        center: Text('Edit ${_lineup.name}', style: TextStyles.title1),
        trailing: CustomIconButton(
          onTap: () async {
            await _saveLineup();
            if (context.mounted) context.pop();
          },
          icon: Icons.check_rounded,
        ),
      ),
      floatingActionButton: CustomFAB.extended(
        child: Text(
          'Options',
          style: TextStyles.title1.copyWith(
            color: AppColors.of(context).onButtonContainer,
          ),
        ),
        onTap: () => context.showModal(EditLineupOptionsModalSheet(
          lineupBoatID: _boat.id,
          com: calculateCOM(boat: _boat, paddlerList: _history.current),
          onChangeBoat: _changeLineupBoat,
        )),
      ),
      //TODO: add clipBehavior to reorderable grid
      body: ListenableBuilder(
        listenable: _history,
        builder: (context, _) => Stack(
          children: [
            AnimatedReorderableGrid(
              length: _history.paddlerLength,
              crossAxisCount: 2,
              overriddenRowCounts: [(0, 1), (_boat.capacity ~/ 2, 1)],
              buildDefaultDragDetectors: false,
              itemBuilder: _itemBuilder,
              rowHeight: kGridRowHeight,
              rowBuilder: (context, index) => boatSegmentBuilder(
                context,
                index,
                _boat.capacity,
              ),
              header: const SizedBox(height: headerPadding),
              footer: SizedBox(height: footerPadding),
              overlay: Selector<SettingsModel, bool>(
                selector: (_, model) => model.showComOverlay,
                builder: (_, visible, child) => Visibility(
                  visible: visible,
                  child: child!,
                ),
                child: COMOverlay(
                  duration: comAnimationDuration,
                  com: calculateCOM(boat: _boat, paddlerList: _history.current),
                  topInset: headerPadding,
                  bottomInset: footerPadding,
                  leftAlignment: 0.25,
                  rightAlignment: 0.75,
                ),
              ),
              keyBuilder: (index) => ValueKey(index),
              onReorder: (oldIndex, newIndex) {
                final paddlerList = _history.current;
                final temp = paddlerList[oldIndex];
                paddlerList[oldIndex] = paddlerList[newIndex];
                paddlerList[newIndex] = temp;
                _history.push(paddlerList);
              },
            ),
            Positioned(
              top: Insets.lg,
              left: Insets.offset,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IgnorePointer(
                    ignoring: !_history.canUndo,
                    child: CustomIconButton(
                      icon: Icons.undo_rounded,
                      onTap: _history.undo,
                    ).animate(target: _history.canUndo ? 1 : 0).fade(
                        duration: comAnimationDuration, begin: 0.5, end: 1),
                  ),
                  SizedBox(width: Insets.med),
                  IgnorePointer(
                    ignoring: !_history.canRedo,
                    child: CustomIconButton(
                      icon: Icons.redo_rounded,
                      onTap: _history.redo,
                    ).animate(target: _history.canRedo ? 1 : 0).fade(
                        duration: comAnimationDuration, begin: 0.5, end: 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
