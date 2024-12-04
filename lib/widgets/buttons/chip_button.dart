import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:flutter/material.dart';

class ChipButton extends StatelessWidget {
  final Color? fillColor;
  final Color? contentColor;
  final GestureTapCallback onTap;
  final Widget child;

  const ChipButton({
    super.key,
    this.fillColor,
    this.contentColor,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveButton(
      onTap: onTap,
      builder: (overlay) {
        final contentColor = Color.alphaBlend(
          overlay,
          this.contentColor ?? AppColors.of(context).neutralContent,
        );
        final outlineColor = Color.alphaBlend(
          overlay,
          this.fillColor ?? Theme.of(context).colorScheme.outlineVariant,
        );
        final fillColor = Color.alphaBlend(
          overlay,
          this.fillColor ?? AppColors.of(context).smallSurface,
        );

        final decoration = ShapeDecoration(
          shape: StadiumBorder(
            side: BorderSide(color: outlineColor),
          ),
          color: fillColor,
        );

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          decoration: decoration,
          child: DefaultTextStyle.merge(
            style: TextStyle(color: contentColor, fontWeight: FontWeight.w500),
            child: IconTheme(
              data: IconThemeData(color: contentColor, size: 20),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
