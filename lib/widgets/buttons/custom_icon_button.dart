import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final IconData icon;

  const CustomIconButton({
    super.key,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveButton(
      onTap: onTap,
      builder: (overlay) => Container(
        padding: const EdgeInsets.all(6),
        decoration: ShapeDecoration(
          shape: StadiumBorder(
            side: BorderSide(
              //TODO: change to divider color once added to AppColors. This is the default M3 divider color.
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          color: AppColors.of(context).smallSurface,
        ),
        child: Icon(
          icon,
          color: Color.alphaBlend(
            overlay,
            AppColors.of(context).neutralContent,
          ),
          size: 20,
        ),
      ),
    );
  }
}
