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
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/navigation_utils.dart';
import 'package:dragonator/models/settings_model.dart';
import 'package:dragonator/widgets/buttons/custom_fab.dart';
import 'package:dragonator/widgets/buttons/custom_icon_button.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:animated_reorderable_grid/animated_reorderable_grid.dart';
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
  late List<Paddler?> _paddlerList;
  late Boat _boat;

  @override
  void initState() {
    super.initState();

    _rosterModel = context.read<RosterModel>();
    _lineup = _rosterModel.getLineup(widget.lineupID)!;
    _paddlerList =
        _lineup.paddlerIDs.map((id) => _rosterModel.getPaddler(id)).toList();
    _boat = _rosterModel.currentTeam!.boats[_lineup.boatID]!;
    _rosterModel.addListener(_checkPaddlerDeleted);
  }

  @override
  void dispose() {
    _rosterModel.removeListener(_checkPaddlerDeleted);
    super.dispose();
  }

  // Remove paddlers from the editing list
  void _checkPaddlerDeleted() {
    final deletedPaddlerNames = <String>[];
    final rosterModel = context.read<RosterModel>();
    for(int i = 0; i < _paddlerList.length; i++) {
      final paddler = _paddlerList[i];
      if(paddler == null) continue;
      if(rosterModel.getPaddler(paddler.id) == null) {
        deletedPaddlerNames.add('${paddler.firstName} ${paddler.lastName}');
        _paddlerList[i] = null;
      }
    }

    setState(() {});
    if(deletedPaddlerNames.isNotEmpty) {
      context.showPopup(PaddlerDeletedPopup(deletedPaddlerNames));
    }
  }

  Future<void> _saveLineup() {
    // TODO: could throw an error if one of these paddlers was deleted. Must check if paddlers are deleted. Maybe also check if lineup was deleted, renamed, i.e. other properties changed.
    return context.read<RosterModel>().setLineup(_lineup.copyWith(
          boatID: _boat.id,
          paddlerIDs: _paddlerList.map((paddler) => paddler?.id),
        ));
  }

  void _changeLineupBoat(Boat boat) {
    setState(() {
      _boat = boat;
      _paddlerList = List<Paddler?>.generate(
        boat.capacity,
        (index) => index < _paddlerList.length ? _paddlerList[index] : null,
      );
    });
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final paddler = _paddlerList[index];
    if (paddler != null) {
      return EditPaddlerTile(
        paddlerID: paddler.id,
        index: index,
        removePaddler: () => setState(() => _paddlerList[index] = null),
      );
    }

    return AddPaddlerTile(
      editedNullablePaddlers: _paddlerList,
      addPaddler: (paddler) {
        if (paddler == null) return;
        //TODO: reorderable grid doesn't internally update items here.
        setState(() => _paddlerList[index] = paddler);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const headerPadding = Insets.med;
    final footerPadding =
        Insets.med + MediaQuery.of(context).viewPadding.bottom;

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
          com: calculateCOM(boat: _boat, paddlerList: _paddlerList),
          onChangeBoat: _changeLineupBoat,
        )),
      ),
      //TODO: add clipBehavior to reorderable grid
      body: AnimatedReorderableGrid(
        length: _paddlerList.length,
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
            duration: const Duration(milliseconds: 250),
            com: calculateCOM(boat: _boat, paddlerList: _paddlerList),
            topInset: headerPadding,
            bottomInset: footerPadding,
            leftAlignment: 0.25,
            rightAlignment: 0.75,
          ),
        ),
        keyBuilder: (index) => ValueKey(index),
        onReorder: (oldIndex, newIndex) => setState(() {
          final temp = _paddlerList[oldIndex];
          _paddlerList[oldIndex] = _paddlerList[newIndex];
          _paddlerList[newIndex] = temp;
        }),
      ),
    );
  }
}
