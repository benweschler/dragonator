import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:flutter/material.dart';

class ChipButton extends StatelessWidget {
  final Color? fillColor;
  final Color? contentColor;
  final GestureTapCallback onTap;
  final Widget child;

  const ChipButton({
    Key? key,
    this.fillColor,
    this.contentColor,
    required this.onTap,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveButton(
      onTap: onTap,
      builder: (overlay) {
        final contentColor = this.contentColor ??
            Color.alphaBlend(overlay, AppColors.of(context).neutralContent);

        final decoration = ShapeDecoration(
          shape: StadiumBorder(
            side: BorderSide(
              //TODO: change to divider color once added to AppColors. This is the default M3 divider color.
              color: fillColor ?? Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          color: fillColor ?? AppColors.of(context).smallSurface,
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
