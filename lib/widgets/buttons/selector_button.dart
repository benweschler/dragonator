import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:flutter/material.dart';

class SelectorButton extends StatelessWidget {
  final bool selected;
  final GestureTapCallback? onTap;

  const SelectorButton({
    super.key,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: 28,
        height: 28,
        margin: EdgeInsets.only(right: Insets.med),
        decoration: BoxDecoration(
          color: selected ? AppColors.of(context).primary : null,
          shape: BoxShape.circle,
          //TODO: black should be onBackground
          border: Border.all(
            color: selected
                ? Colors.transparent
                : AppColors.of(context).outline,
          ),
        ),
        child: selected
            //TODO: should be onPrimary
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
