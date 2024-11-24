import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:flutter/material.dart';

import 'responsive_buttons.dart';

const double _fabRadius = 56;

enum _FABType { regular, extended }

/// A custom implementation of a floating action button.
class CustomFAB extends StatelessWidget {
  final Widget child;
  final GestureTapCallback onTap;
  final _FABType _type;

  const CustomFAB({
    super.key,
    required this.child,
    required this.onTap,
  }) : _type = _FABType.regular;

  const CustomFAB.extended({
    super.key,
    required this.child,
    required this.onTap,
  }) : _type = _FABType.extended;

  @override
  Widget build(BuildContext context) {
    final contentColor = AppColors.of(context).onButtonContainer;

    return DefaultTextStyle.merge(
      style: TextStyle(color: contentColor),
      child: IconTheme.merge(
        data: IconThemeData(color: contentColor),
        child: ResponsiveButton(
          onTap: onTap,
          builder: (overlay) => Material(
            elevation: 6.0,
            shape: const CircleBorder(),
            child: Container(
              width: _type == _FABType.regular ? _fabRadius : null,
              height: _type == _FABType.regular ? _fabRadius : null,
              padding: _type == _FABType.regular
                  ? null
                  : const EdgeInsets.symmetric(vertical: Insets.med, horizontal: Insets.lg),
              decoration: ShapeDecoration(
                shape: _type == _FABType.regular
                    ? const CircleBorder()
                    : const StadiumBorder(),
                color: Color.alphaBlend(
                  overlay,
                  AppColors.of(context).buttonContainer,
                ),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
