import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:flutter/material.dart';

class SelectorButton extends StatelessWidget {
  final bool selected;
  final GestureTapCallback onTap;

  const SelectorButton({
    super.key,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: selected ? AppColors.of(context).accent : null,
          shape: BoxShape.circle,
          //TODO: black should be onBackground
          border: Border.all(
            color: selected ? Colors.transparent : Colors.black,
          ),
        ),
        child: selected
        //TODO: should be onAccent
            ? const Icon(
          Icons.check_rounded,
          color: Colors.white,
          size: Insets.lg,
        )
            : null,
      ),
    );
  }
}
