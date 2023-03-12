import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final IconData icon;

  const OptionButton({
    Key? key,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveButton(
      onTap: onTap,
      builder: (overlay) => Container(
        padding: const EdgeInsets.all(Insets.xs),
        decoration: ShapeDecoration(
          shape: const StadiumBorder(),
          color: AppColors.of(context).neutralSurface,
        ),
        child: Icon(
          icon,
          color: Color.alphaBlend(
            overlay,
            AppColors.of(context).neutralContent,
          ),
          size: 18,
        ),
      ),
    );
  }
}
