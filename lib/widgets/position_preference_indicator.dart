import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:flutter/material.dart';

class PositionPreferenceIndicator extends StatelessWidget {
  final String label;
  final bool hasPreference;

  const PositionPreferenceIndicator({
    super.key,
    required this.label,
    required this.hasPreference,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(Insets.sm),
          padding: EdgeInsets.all(Insets.sm),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: hasPreference ? AppColors.of(context).primarySurface : null,
            border: Border.all(
              width: 1.5,
              color: hasPreference
                  ? AppColors.of(context).primary
                  : AppColors.of(context).outline,
            ),
          ),
          child: Icon(
            hasPreference ? Icons.check_rounded : Icons.close_rounded,
            size: TextStyles.h2.fontSize,
            color: hasPreference
                ? AppColors.of(context).primary
                : AppColors.of(context).neutralContent,
          ),
        ),
        Text(label, style: TextStyles.body1),
      ],
    );
  }
}
