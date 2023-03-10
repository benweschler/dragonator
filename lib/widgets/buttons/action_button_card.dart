import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:flutter/material.dart';

const double _actionButtonPadding = Insets.med;

class ActionButtonCard extends StatelessWidget {
  final List<ActionButton> actionButtons;

  const ActionButtonCard(this.actionButtons, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: _actionButtonPadding),
      decoration: BoxDecoration(
        borderRadius: Corners.smBorderRadius,
        color: AppColors.of(context).largeSurface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //TODO: this is terrible. fix this.
        children: <Widget>[...actionButtons]
            //TODO: used divider
            .separate(const Divider(height: 0.5, thickness: 0.5))
            .toList(),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final IconData icon;
  final String label;

  const ActionButton({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveButton(
      onTap: onTap,
      builder: (overlay) => Padding(
        padding: const EdgeInsets.symmetric(vertical: _actionButtonPadding),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Color.alphaBlend(overlay, AppColors.of(context).accent),
            ),
            const SizedBox(width: Insets.sm),
            Text(
              label,
              style: TextStyles.body2.copyWith(
                color: Color.alphaBlend(
                  overlay,
                  DefaultTextStyle.of(context).style.color!,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
