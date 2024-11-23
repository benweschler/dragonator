import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:flutter/material.dart';

const double _actionButtonPadding = Insets.med;

class ActionButtonCard extends StatelessWidget {
  final List<ActionButton> actionButtons;

  const ActionButtonCard(this.actionButtons, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: _actionButtonPadding),
      decoration: BoxDecoration(
        //TODO: change to divider color once added to AppColors. This is the default M3 divider color.
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: Corners.smBorderRadius,
        color: AppColors.of(context).largeSurface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
    super.key,
    required this.onTap,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveStrokeButton(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: _actionButtonPadding),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.of(context).primary,
            ),
            const SizedBox(width: Insets.sm),
            Text(label),
          ],
        ),
      ),
    );
  }
}
