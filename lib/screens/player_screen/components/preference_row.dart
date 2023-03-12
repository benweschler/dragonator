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
    final icon = hasPreference
        ? Icon(Icons.check_circle_rounded, color: AppColors.of(context).accent)
        : const Icon(Icons.circle_outlined);

    return Row(
      children: [
        icon,
        const SizedBox(width: Insets.sm),
        Text(label),
      ],
    );
  }
}
