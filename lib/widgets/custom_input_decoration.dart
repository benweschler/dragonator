import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:flutter/material.dart';

class CustomInputDecoration extends InputDecoration {
  final AppColors colors;

  CustomInputDecoration(
    this.colors, {
    super.suffix,
    super.suffixIcon,
    super.hintText,
  }) : super(
          contentPadding: const EdgeInsets.all(Insets.sm),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: colors.neutralContent.withOpacity(0.2),
            ),
            borderRadius: Corners.medBorderRadius,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1),
            borderRadius: Corners.medBorderRadius,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: colors.accent),
            borderRadius: Corners.medBorderRadius,
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: colors.accent),
            borderRadius: Corners.medBorderRadius,
          ),
        );
}
