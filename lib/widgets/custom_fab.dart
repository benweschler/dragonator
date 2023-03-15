import 'package:flutter/material.dart';

import 'buttons/responsive_buttons.dart';

const double _fabRadius = 56;

/// A custom implementation of a floating action button.
class CustomFAB extends StatelessWidget {
  final Color color;
  final Widget child;
  final GestureTapCallback onTap;

  const CustomFAB({
    Key? key,
    required this.color,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveButton(
      onTap: onTap,
      builder: (overlay) => Material(
        elevation: 6.0,
        shape: const CircleBorder(),
        child: Container(
          width: _fabRadius,
          height: _fabRadius,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.alphaBlend(overlay, Colors.black),
          ),
          child: child,
        ),
      ),
    );
  }
}
