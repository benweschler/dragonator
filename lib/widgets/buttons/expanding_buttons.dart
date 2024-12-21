import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:flutter/material.dart';

class ExpandingStadiumButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final Color color;
  final Color textColor;
  final bool enabled;
  final String label;

  const ExpandingStadiumButton({
    super.key,
    required this.onTap,
    required this.color,
    this.textColor = Colors.white,
    this.enabled = true,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enabled,
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: ResponsiveButton.large(
          onTap: onTap,
          builder: (overlay) => SizedBox(
            width: double.infinity,
            child: Material(
              elevation: 8.0,
              color: Color.alphaBlend(overlay, color),
              shape: const StadiumBorder(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Insets.sm,
                  horizontal: Insets.med,
                ),
                child: Text(
                  label,
                  style: TextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ExpandingTextButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final String text;
  final Color? textColor;

  const ExpandingTextButton({
    super.key,
    required this.onTap,
    required this.text,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveStrokeButton(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: Insets.sm),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyles.body1.copyWith(
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
