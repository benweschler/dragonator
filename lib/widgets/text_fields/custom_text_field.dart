import 'package:dragonator/styles/styles.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? hintText;

  const CustomTextField({
    Key? key,
    this.controller,
    this.focusNode,
    this.obscureText = false,
    this.keyboardType,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.all(Insets.med),
        isDense: true,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1),
          borderRadius: Corners.medBorderRadius,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 2),
          borderRadius: Corners.medBorderRadius,
        ),
      ),
    );
  }
}
