import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:dragonator/widgets/modal_sheets/modal_sheet.dart';
import 'package:dragonator/widgets/modal_sheets/selection_menu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//TODO: this needs to be cleaned up
class SortingOptionsMenu extends StatefulWidget {
  final Iterable<String> sortingStrategies;
  final String initiallySelectedStrategy;
  final bool sortIncreasing;
  final void Function(String sortingStrategy, bool sortIncreasing) onSave;

  const SortingOptionsMenu({
    Key? key,
    required this.sortingStrategies,
    required this.initiallySelectedStrategy,
    required this.sortIncreasing,
    required this.onSave,
  }) : super(key: key);

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                .toList(),
            //TODO: using divider here
          ].separate(const Divider(height: 0.5, thickness: 0.5)).toList(),
          _ApplyButton(
            onTap: () => widget.onSave(selectedStrategy, sortIncreasing),
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
    Key? key,
    required this.sortIncreasing,
    required this.onDirectionChanged,
  }) : super(key: key);

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
                sortIncreasing ? 'Increasing' : 'Decreasing',
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

class _ApplyButton extends StatelessWidget {
  final GestureTapCallback onTap;

  const _ApplyButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveButton.large(
      onTap: () {
        onTap();
        context.pop();
      },
      builder: (overlay) => Padding(
        padding: const EdgeInsets.only(
          top: Insets.xs,
          left: Insets.offset,
          right: Insets.offset,
          bottom: Insets.offset,
        ),
        child: Container(
          padding: const EdgeInsets.all(Insets.med),
          decoration: BoxDecoration(
            borderRadius: Corners.medBorderRadius,
            color: Color.alphaBlend(overlay, AppColors.of(context).accent),
          ),
          child: const Center(
            child: Text(
              'Apply',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
