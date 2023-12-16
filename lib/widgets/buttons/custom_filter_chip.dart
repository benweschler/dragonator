import 'dart:math';

import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:dragonator/utils/navigator_utils.dart';
import 'package:dragonator/widgets/buttons/chip_button.dart';
import 'package:dragonator/widgets/modal_sheets/modal_sheet.dart';
import 'package:dragonator/widgets/modal_sheets/selection_menu.dart';
import 'package:flutter/material.dart';

import 'modal_sheet_expanded_button.dart';

class CustomFilterChip<T> extends StatefulWidget {
  final String label;
  final ValueChanged<T?> onFiltered;
  final List<T> options;

  const CustomFilterChip({
    super.key,
    required this.label,
    required this.onFiltered,
    required this.options,
  });

  @override
  State<CustomFilterChip> createState() => _CustomFilterChipState<T>();
}

class _CustomFilterChipState<T> extends State<CustomFilterChip<T>> {
  bool isActive = false;
  T? selectedOption;

  @override
  Widget build(BuildContext context) {
    return ChipButton(
      onTap: () => context.showModal(_SelectFilterMenu<T>(
        options: widget.options,
        initiallySelectedMenuOption: selectedOption,
        onSave: (option) => setState(() {
          isActive = option != null ? true : false;
          selectedOption = option;
          widget.onFiltered(option);
        }),
      )),
      fillColor: isActive ? AppColors.of(context).primaryContainer : null,
      contentColor: isActive ? AppColors.of(context).onPrimaryContainer : null,
      child: Row(
        children: [
          Text(
            isActive ? '${widget.label}: $selectedOption' : widget.label,
          ),
          const SizedBox(width: Insets.xs),
          Transform.rotate(
            angle: pi / 2,
            child: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }
}

//TODO: change to using apply button like sorting options menu.
//TODO: move to separate file
class _SelectFilterMenu<T> extends StatefulWidget {
  final Iterable<T> options;
  final T? initiallySelectedMenuOption;
  final ValueChanged<T?> onSave;

  const _SelectFilterMenu({
    super.key,
    required this.options,
    required this.initiallySelectedMenuOption,
    required this.onSave,
  });

  @override
  State<_SelectFilterMenu> createState() => _SelectFilterMenuState<T>();
}

class _SelectFilterMenuState<T> extends State<_SelectFilterMenu<T>> {
  late T? selectedMenuOption = widget.initiallySelectedMenuOption;

  void onTap(T? option) {
    setState(() {
      if (selectedMenuOption == option) {
        selectedMenuOption = null;
      } else {
        selectedMenuOption = option;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalSheet(
      child: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...widget.options
                  .map<Widget>((option) => SelectionMenuTile(
                        label: option.toString(),
                        isSelected: option == selectedMenuOption,
                        onTap: () => onTap(option),
                      ))
                  .separate(const Divider(height: 0.5, thickness: 0.5)),
              ModalSheetButtonTile(
                color: AppColors.of(context).accent,
                onTap: () => widget.onSave(selectedMenuOption),
                label: 'Apply',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
