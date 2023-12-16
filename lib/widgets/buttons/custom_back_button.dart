import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveStrokeButton(
      onTap: context.pop,
      child: const Icon(Icons.arrow_back_ios_new_rounded),
    );
  }
}
