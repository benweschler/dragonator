import 'dart:math';

import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:flutter/material.dart';

class PreferenceRow extends StatelessWidget {
  final String label;
  final bool hasPreference;

  const PreferenceRow({
    Key? key,
    required this.label,
    required this.hasPreference,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget icon;
    if (hasPreference) {
      icon = Icon(
        Icons.check_circle_rounded,
        color: AppColors.of(context).accent,
      );
    } else {
      icon = Transform.rotate(
        angle: pi / 4,
        child: Icon(
          Icons.add_circle_outline_rounded,
          color: AppColors.of(context).neutralContent,
        ),
      );
    }

    return Row(
      children: [
        icon,
        const SizedBox(width: Insets.med),
        Text(label),
      ],
    );
  }
}
