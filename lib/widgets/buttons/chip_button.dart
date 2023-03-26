import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:flutter/material.dart';

class ChipButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final Widget child;
  final bool isActive;

  const ChipButton({
    Key? key,
    required this.onTap,
    this.isActive = false,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveButton(
      onTap: onTap,
      builder: (overlay) {
        final contentColor = isActive
            ? Colors.white
            : Color.alphaBlend(
                overlay,
                AppColors.of(context).neutralContent,
              );

        final decoration = isActive
            ? ShapeDecoration(
                shape: const StadiumBorder(),
                color: AppColors.of(context).accent,
              )
            : ShapeDecoration(
                shape: StadiumBorder(
                  side: BorderSide(
                    //TODO: change to divider color once added to AppColors. This is the default M3 divider color.
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                color: AppColors.of(context).smallSurface,
              );

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
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
