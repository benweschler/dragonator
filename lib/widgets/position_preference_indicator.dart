import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:flutter/material.dart';

class PositionPreferenceIndicator extends StatelessWidget {
  final String label;
  final Color? overlay;
  final bool hasPreference;

  const PositionPreferenceIndicator({
    super.key,
    required this.label,
    this.overlay,
    required this.hasPreference,
  });

  @override
  Widget build(BuildContext context) {
    final overlay = this.overlay ?? Colors.transparent;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Insets.sm,
        horizontal: Insets.lg,
      ),
      decoration: BoxDecoration(
        borderRadius: Corners.medBorderRadius,
        color: hasPreference ? AppColors.of(context).primarySurface : null,
        border: Border.all(
          color: Color.alphaBlend(
            overlay,
            hasPreference
                ? AppColors.of(context).primary
                : AppColors.of(context).outline,
          ),
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              hasPreference ? Icons.check_rounded : Icons.close_rounded,
              color: Color.alphaBlend(
                overlay,
                hasPreference
                    ? AppColors.of(context).primary
                    : AppColors.of(context).neutralContent,
              ),
            ),
          ),
          Center(
            child: Text(
              label,
              style: TextStyles.body1.copyWith(
                color: Color.alphaBlend(
                  overlay,
                  hasPreference
                      ? AppColors.of(context).primary
                      : AppColors.of(context).neutralContent,
                ),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
