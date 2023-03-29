import 'dart:math';

import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/chip_button.dart';
import 'package:flutter/material.dart';

class CustomFilterChip<T> extends StatefulWidget {
  final String label;
  final void Function(T) onFiltered;
  final Iterable<T> options;

  const CustomFilterChip({
    Key? key,
    required this.label,
    required this.onFiltered,
    required this.options,
  }) : super(key: key);

  @override
  State<CustomFilterChip> createState() => _CustomFilterChipState<T>();
}

class _CustomFilterChipState<T> extends State<CustomFilterChip<T>> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return ChipButton(
      onTap: () => setState(() => isActive = !isActive),
      fillColor: isActive ? AppColors.of(context).primaryContainer : null,
      contentColor: isActive ? AppColors.of(context).onPrimaryContainer : null,
      child: Row(
        children: [
          Text(isActive ? widget.options.first.toString() : widget.label),
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
