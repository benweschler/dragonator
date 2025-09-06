import 'dart:math';

import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/navigation_utils.dart';
import 'package:dragonator/widgets/buttons/chip_button.dart';
import 'package:dragonator/widgets/modal_sheets/selection_menu.dart';
import 'package:flutter/material.dart';

class CustomFilterChip<T> extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isActive = selectedOption != null;

    return ChipButton(
      onTap: () => context.showModal(SelectionMenu<T>.single(
        options: options,
        initiallySelectedOption: selectedOption,
        allowNoSelection: true,
        onSelect: onFiltered,
      )),
      fillColor: isActive ? AppColors.of(context).buttonContainer : null,
      contentColor: isActive ? AppColors.of(context).onButtonContainer : null,
      child: Row(
        children: [
          Text(
            isActive
                ? '$label: $selectedOption'
                : label,
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
