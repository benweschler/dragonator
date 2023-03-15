import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// A styled version of a [FormBuilderTextField].
class CustomTextFormField extends StatelessWidget {
  final String name;
  final String? initialValue;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? hintText;
  final Widget? suffix;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextFormField({
    Key? key,
    required this.name,
    this.initialValue,
    this.validator,
    this.focusNode,
    this.obscureText = false,
    this.keyboardType,
    this.hintText,
    this.suffix,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accentColor = AppColors.of(context).accent;
    return FormBuilderTextField(
      name: name,
      initialValue: initialValue,
      validator: validator,
      focusNode: focusNode,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(Insets.sm),
        isDense: true,
        suffix: suffix,
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: AppColors.of(context).neutralContent.withOpacity(0.2),
          ),
          borderRadius: Corners.medBorderRadius,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1),
          borderRadius: Corners.medBorderRadius,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: accentColor),
          borderRadius: Corners.medBorderRadius,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: accentColor),
          borderRadius: Corners.medBorderRadius,
        ),
      ),
    );
  }
}
