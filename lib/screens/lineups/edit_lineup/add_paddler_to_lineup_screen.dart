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

import 'utils.dart';

class AddPaddlerToLineupScreen extends StatefulWidget {
  /// The list of paddlers in the current state of the edited lineup.
  final List<Paddler> unassignedPaddlers;

  /// A callback to add a paddler to the edited lineup.
  final ValueChanged<Paddler?> addPaddler;

  /// The side of the seat being filled. A null value represents either the fore
  /// or aft seat, which are centered.
  final SidePreference? side;

  /// The position of the seat being filled, if applicable.
  final Position? position;

  const AddPaddlerToLineupScreen({
    super.key,
    required this.unassignedPaddlers,
    required this.addPaddler,
    required this.side,
    required this.position,
  });

  @override
  State<AddPaddlerToLineupScreen> createState() =>
      _AddPaddlerToLineupScreenState();
}

class _AddPaddlerToLineupScreenState extends State<AddPaddlerToLineupScreen> {
  late Position? positionFilter = widget.position;
  late SidePreference? sidePreferenceFilter = widget.side;
  String? _selectedPaddlerID;

  @override
  Widget build(BuildContext context) {
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
            options: Position.values,
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
          widget.addPaddler(
            context.read<RosterModel>().getPaddler(_selectedPaddlerID),
          );
          context.pop();
        },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Insets.lg),
          Padding(
            padding: EdgeInsets.only(left: Insets.offset),
            child: filterRow,
          ),
          SizedBox(height: Insets.sm),
          Expanded(
            child: _PaddlerList(
              unassignedPaddlers: widget.unassignedPaddlers,
              selectedPaddlerID: _selectedPaddlerID,
              onSelect: (selectedID) => setState(() {
                _selectedPaddlerID =
                    _selectedPaddlerID == selectedID ? null : selectedID;
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
  final Iterable<Paddler> unassignedPaddlers;
  final String? selectedPaddlerID;
  final ValueChanged<String> onSelect;
  final SidePreference? sidePreferenceFilter;
  final Position? positionFilter;

  const _PaddlerList({
    required this.unassignedPaddlers,
    required this.selectedPaddlerID,
    required this.onSelect,
    required this.sidePreferenceFilter,
    required this.positionFilter,
  });

  (List<Paddler> matchedPaddlers, List<Paddler> unmatchedPaddlers)
      _filterPaddlers(Iterable<Paddler> paddlers) {
    final List<Paddler> matchedPaddlers = [];
    final List<Paddler> unmatchedPaddlers = [];
    for (Paddler paddler in paddlers) {
      // If the side preference filter is present and fails, no need to check
      // the position filter.
      if (sidePreferenceFilter != null &&
          paddler.sidePreference != sidePreferenceFilter) {
        unmatchedPaddlers.add(paddler);
        continue;
      }

      // If the position filter is not present, pass the paddler to the filtered
      // list by returning true.
      if (positionFilter?.filter(paddler) ?? true) {
        matchedPaddlers.add(paddler);
      } else {
        unmatchedPaddlers.add(paddler);
      }
    }

    return (matchedPaddlers, unmatchedPaddlers);
  }

  void _buildPaddlerTiles(List<Widget> children, List<Paddler> paddlers) {
    for (Paddler paddler in paddlers) {
      children.add(IntrinsicHeight(
        child: Row(
          // Stretch the hit box of the selector button to cover the entire
          // height of the tile.
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SelectorButton(
              selected: selectedPaddlerID == paddler.id,
              onTap: () => onSelect(paddler.id),
            ),
            Expanded(child: PaddlerPreviewTile(paddler)),
            SizedBox(width: Insets.offset),
          ],
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (unassignedPaddlers.isEmpty) {
      return Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child: Selector<RosterModel, Iterable<Paddler>>(
            selector: (_, model) => model.paddlers,
            builder: (_, rosterPaddlers, __) => Text(
              rosterPaddlers.isEmpty
                  ? 'This team has no paddlers.'
                  : 'All paddlers are already in this lineup.',
              style: TextStyles.body1,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final (matchedPaddlers, unmatchedPaddlers) =
        _filterPaddlers(unassignedPaddlers);

    final List<Widget> children = [];
    if (matchedPaddlers.isEmpty) {
      children.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: Insets.xl),
        child: Align(
          alignment: Alignment.topCenter,
          child: Text(
            'No matching paddlers',
            style: TextStyle(color: AppColors.of(context).neutralContent),
          ),
        ),
      ));
    } else {
      _buildPaddlerTiles(children, matchedPaddlers);
    }

    if (unmatchedPaddlers.isNotEmpty) {
      // If there are no matched paddlers, the 'No matching paddlers' text
      // should be centered between the filter row and the title of the
      // following section. Because this text has its own padding, less padding
      // is required here.
      final topPadding = matchedPaddlers.isNotEmpty ? Insets.xl : Insets.sm;
      children.add(SizedBox(height: topPadding));

      children.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: Insets.offset),
        child: Text('Other Paddlers', style: TextStyles.h2),
      ));
      children.add(SizedBox(height: Insets.xs));
      _buildPaddlerTiles(children, unmatchedPaddlers);
    }

    return ListView(children: children);
  }
}
