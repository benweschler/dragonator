import 'package:dragonator/styles/theme.dart';
import 'package:flutter/material.dart';

import 'responsive_buttons.dart';

const double _fabRadius = 56;

/// A custom implementation of a floating action button.
class CustomFAB extends StatelessWidget {
  final Widget child;
  final GestureTapCallback onTap;

  const CustomFAB({
    Key? key,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contentColor = AppColors.of(context).onPrimaryContainer;

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
              width: _fabRadius,
              height: _fabRadius,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.alphaBlend(overlay, AppColors.of(context).primaryContainer),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
