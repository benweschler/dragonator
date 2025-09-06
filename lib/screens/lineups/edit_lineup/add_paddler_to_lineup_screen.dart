import 'package:dragonator/data/paddler/paddler.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:dragonator/widgets/buttons/custom_filter_chip.dart';
import 'package:dragonator/widgets/buttons/custom_icon_button.dart';
import 'package:dragonator/widgets/buttons/selector_button.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:dragonator/widgets/preview_tiles/paddler_preview_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

bool steersPersonFilter(Paddler paddler) => paddler.steersPersonPreference;

bool drummerFilter(Paddler paddler) => paddler.drummerPreference;

bool strokeFilter(Paddler paddler) => paddler.strokePreference;

enum _Position {
  drummer,
  steersPerson,
  stroke;

  bool filter(Paddler paddler) {
    switch (this) {
      case _Position.drummer:
        return drummerFilter(paddler);
      case _Position.steersPerson:
        return steersPersonFilter(paddler);
      case _Position.stroke:
        return strokeFilter(paddler);
    }
  }

  @override
  String toString() {
    switch (this) {
      case _Position.drummer:
        return 'Drummer';
      case _Position.steersPerson:
        return 'Steers Person';
      case _Position.stroke:
        return 'Stroke';
    }
  }
}

class AddPaddlerToLineupScreen extends StatefulWidget {
  /// The list of paddlers in the current state of the edited lineup.
  final Iterable<Paddler> editedLineupPaddlers;

  /// A callback to add a paddler to the edited lineup.
  final ValueChanged<Paddler?> addPaddler;

  const AddPaddlerToLineupScreen({
    super.key,
    //TODO: just pass the paddlers we want?
    required this.editedLineupPaddlers,
    required this.addPaddler,
  });

  @override
  State<AddPaddlerToLineupScreen> createState() =>
      _AddPaddlerToLineupScreenState();
}

class _AddPaddlerToLineupScreenState extends State<AddPaddlerToLineupScreen> {
  _Position? positionFilter;
  SidePreference? sidePreferenceFilter;
  int? _selectedPaddlerIndex;

  @override
  Widget build(BuildContext context) {
    final rosterModel = context.watch<RosterModel>();
    // Only show paddlers that aren't in the lineup.
    final rosterPaddlers = rosterModel.paddlers.toSet();
    final unassignedPaddlers =
        rosterPaddlers.difference(widget.editedLineupPaddlers.toSet()).toList();

    final filterRow = SingleChildScrollView(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: <Widget>[
          CustomFilterChip(
            label: 'Position',
            onFiltered: (position) => setState(() => positionFilter = position),
            selectedOption: positionFilter,
            options: _Position.values,
          ),
          CustomFilterChip(
            label: 'Side',
            onFiltered: (side) => setState(() => sidePreferenceFilter = side),
            selectedOption: sidePreferenceFilter,
            options: SidePreference.values,
          ),
        ].separate(const SizedBox(width: Insets.sm)).toList(),
      ),
    );

    return CustomScaffold(
      addScreenInset: false,
      leading: CustomIconButton(
        icon: Icons.close_rounded,
        onTap: () => context.pop(),
      ),
      center: const Text('Add Paddler to Lineup', style: TextStyles.title1),
      trailing: CustomIconButton(
        icon: Icons.check_rounded,
        onTap: () {
          widget.addPaddler(_selectedPaddlerIndex != null
              ? unassignedPaddlers[_selectedPaddlerIndex!]
              : null);
          context.pop();
        },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Insets.lg),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Insets.offset),
            child: filterRow,
          ),
          SizedBox(height: Insets.xs),
          Expanded(
            child: _PaddlerList(
              rosterPaddlers: rosterPaddlers,
              unassignedPaddlers: unassignedPaddlers,
              selectedPaddlerIndex: _selectedPaddlerIndex,
              onSelect: (selectedIndex) => setState(() {
                _selectedPaddlerIndex == selectedIndex
                    ? _selectedPaddlerIndex = null
                    : _selectedPaddlerIndex = selectedIndex;
              }),
              sidePreferenceFilter: sidePreferenceFilter,
              positionFilter: positionFilter,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaddlerList extends StatelessWidget {
  final Iterable<Paddler> rosterPaddlers;
  final List<Paddler> unassignedPaddlers;
  final int? selectedPaddlerIndex;
  final ValueChanged<int> onSelect;
  final SidePreference? sidePreferenceFilter;
  final _Position? positionFilter;

  const _PaddlerList({
    required this.rosterPaddlers,
    required this.unassignedPaddlers,
    required this.selectedPaddlerIndex,
    required this.onSelect,
    required this.sidePreferenceFilter,
    required this.positionFilter,
  });

  List<Paddler> _filterPaddlers(List<Paddler> paddlers) {
    return paddlers.where((paddler) {
      if (sidePreferenceFilter != null &&
          paddler.sidePreference != sidePreferenceFilter) {
        return false;
      }

      return positionFilter?.filter(paddler) ?? true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (unassignedPaddlers.isEmpty) {
      return Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child: Text(
            rosterPaddlers.isEmpty
                ? 'This team has no paddlers.'
                : 'All paddlers are already in this lineup.',
            style: TextStyles.body1,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final filteredPaddlers = _filterPaddlers(unassignedPaddlers);
    if (filteredPaddlers.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Insets.xl),
        child: Align(
          alignment: Alignment.topCenter,
          child: Text(
            'No matching paddlers',
            style: TextStyle(color: AppColors.of(context).neutralContent),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredPaddlers.length,
      itemBuilder: (context, index) => IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SelectorButton(
              selected: selectedPaddlerIndex == index,
              onTap: () => onSelect(index),
            ),
            Expanded(child: PaddlerPreviewTile(filteredPaddlers[index])),
            SizedBox(width: Insets.offset),
          ],
        ),
      ),
    );
  }
}
