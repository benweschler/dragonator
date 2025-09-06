import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
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
    return ResponsiveButton(
      onTap: onTap,
      builder: (overlay) => Container(
        width: 28,
        height: 28,
        //TODO: why is there a margin
        margin: EdgeInsets.all(Insets.med),
        decoration: BoxDecoration(
          color: selected
              ? Color.alphaBlend(overlay, AppColors.of(context).primary)
              : null,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected
                ? Colors.transparent
                : Color.alphaBlend(overlay, AppColors.of(context).outline),
          ),
        ),
        child: selected
            //TODO: should be onPrimary
            ? Icon(
                Icons.check_rounded,
                color: Color.alphaBlend(overlay, Colors.white),
                size: Insets.lg,
              )
            : null,
      ),
    );
  }
}
