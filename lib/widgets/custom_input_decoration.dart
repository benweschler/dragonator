import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:flutter/material.dart';

class CustomInputDecoration extends InputDecoration {
  final AppColors colors;

  CustomInputDecoration(
    this.colors, {
    bool showEmptyErrorText = false,
    super.suffix,
    super.hintText,
  }) : super(
          filled: true,
          fillColor: colors.largeSurface,
          errorStyle: TextStyles.caption.copyWith(
            color: colors.accent,
            fontWeight: FontWeight.w500,
            height: showEmptyErrorText ? null : 0,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: Insets.sm,
            horizontal: Insets.med,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: colors.neutralContent.withOpacity(0.2),
            ),
            borderRadius: Corners.medBorderRadius,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              //TODO: change to use text color
              color: colors.primaryContainer,
            ),
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
