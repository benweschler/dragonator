import 'dart:math';

import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/navigation_utils.dart';
import 'package:dragonator/widgets/buttons/chip_button.dart';
import 'package:dragonator/widgets/modal_sheets/selection_menu.dart';
import 'package:flutter/material.dart';

class CustomFilterChip<T> extends StatefulWidget {
  final String label;
  final ValueChanged<T?> onFiltered;
  final T? selectedOption;
  final List<T> options;

  const CustomFilterChip({
    super.key,
    required this.label,
    required this.onFiltered,
    required this.selectedOption,
    required this.options,
  });

  @override
  State<CustomFilterChip> createState() => _CustomFilterChipState<T>();
}

class _CustomFilterChipState<T> extends State<CustomFilterChip<T>> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return ChipButton(
      onTap: () => context.showModal(SelectionMenu<T>.single(
        options: widget.options,
        initiallySelectedOption: widget.selectedOption,
        allowNoSelection: true,
        onSelect: (option) => setState(() {
          isActive = option != null ? true : false;
          widget.onFiltered(option);
        }),
      )),
      fillColor: isActive ? AppColors.of(context).buttonContainer : null,
      contentColor: isActive ? AppColors.of(context).onButtonContainer : null,
      child: Row(
        children: [
          Text(
            isActive
                ? '${widget.label}: ${widget.selectedOption}'
                : widget.label,
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
