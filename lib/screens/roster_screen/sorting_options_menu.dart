import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:dragonator/widgets/buttons/modal_sheet_expanded_button.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:dragonator/widgets/modal_sheets/modal_sheet.dart';
import 'package:dragonator/widgets/modal_sheets/selection_menu.dart';
import 'package:flutter/material.dart';

class SortingOptionsMenu extends StatefulWidget {
  final Iterable<String> sortingStrategies;
  final String initiallySelectedStrategy;
  final bool sortIncreasing;
  final void Function(String sortingStrategy, bool sortIncreasing) onSave;

  const SortingOptionsMenu({
    super.key,
    required this.sortingStrategies,
    required this.initiallySelectedStrategy,
    required this.sortIncreasing,
    required this.onSave,
  });

  @override
  State<SortingOptionsMenu> createState() => _SortingOptionsMenuState();
}

class _SortingOptionsMenuState extends State<SortingOptionsMenu> {
  late String selectedStrategy = widget.initiallySelectedStrategy;
  late bool sortIncreasing = widget.sortIncreasing;

  @override
  Widget build(BuildContext context) {
    return ModalSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...<Widget>[
            _SortDirectionSelector(
              sortIncreasing: sortIncreasing,
              onDirectionChanged: (value) =>
                  setState(() => sortIncreasing = value),
            ),
            ...widget.sortingStrategies
                .map((strategy) => SelectionMenuTile(
                      label: strategy,
                      isSelected: selectedStrategy == strategy,
                      onTap: () => setState(() => selectedStrategy = strategy),
                    ))
                ,
            //TODO: using divider here
          ].separate(const Divider(height: 0.5, thickness: 0.5)),
          ModalSheetButtonTile(
            color: AppColors.of(context).accent,
            onTap: () => widget.onSave(selectedStrategy, sortIncreasing),
            label: 'Apply',
          ),
        ],
      ),
    );
  }
}

class _SortDirectionSelector extends StatelessWidget {
  final bool sortIncreasing;
  final ValueChanged<bool> onDirectionChanged;

  const _SortDirectionSelector({
    required this.sortIncreasing,
    required this.onDirectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Insets.med),
      child: Row(
        children: [
          ResponsiveButton(
            onTap: () => onDirectionChanged(true),
            builder: (_) => Container(
              padding: const EdgeInsets.all(Insets.xs),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: sortIncreasing ? AppColors.of(context).accent : null,
              ),
              child: Icon(
                Icons.arrow_upward_rounded,
                color: sortIncreasing ? Colors.white : null,
              ),
            ),
          ),
          const SizedBox(width: Insets.med),
          Expanded(
            child: Center(
              child: Text(
                sortIncreasing ? 'Ascending' : 'Descending',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(width: Insets.med),
          ResponsiveButton(
            onTap: () => onDirectionChanged(false),
            builder: (_) => Container(
              padding: const EdgeInsets.all(Insets.xs),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: sortIncreasing ? null : AppColors.of(context).accent,
              ),
              child: Icon(
                Icons.arrow_downward_rounded,
                color: sortIncreasing ? null : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
