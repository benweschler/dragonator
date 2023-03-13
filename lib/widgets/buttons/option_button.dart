import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:flutter/material.dart';

//TODO: this is probably a bad way to encapsulate this widget. Also, add documentation.
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
        padding: const EdgeInsets.all(6),
        decoration: ShapeDecoration(
          shape: const StadiumBorder(),
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
