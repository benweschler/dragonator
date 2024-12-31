import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:flutter/material.dart';

class ErrorCard extends StatelessWidget {
  final String message;

  const ErrorCard(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.all(Insets.sm),
        decoration: BoxDecoration(
          borderRadius: Corners.medBorderRadius,
          color: colors.largeErrorSurface,
          border: Border.all(color: colors.error),
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyles.body2.copyWith(
            fontWeight: FontWeight.w500,
            color: colors.error,
          ),
        ),
      ),
    );
  }
}
