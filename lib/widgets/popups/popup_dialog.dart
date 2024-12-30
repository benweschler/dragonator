import 'package:dragonator/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PopupDialog extends StatelessWidget {
  final Widget child;

  const PopupDialog({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      // Avoid the onscreen keyboard.
      padding: MediaQuery.viewInsetsOf(context),
      // The default duration and curve for the build-in Dialog widget.
      duration: Duration(milliseconds: 100),
      curve: Curves.decelerate,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.85,
            ),
            child: Material(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: Corners.medBorderRadius,
              clipBehavior: Clip.antiAlias,
              elevation: 15,
              // Do not add padding to avoid clipping shadows.
              child: child,
            ).animate().slideY(
                  // The the default duration of the transition animation in
                  // showDialog.
                  duration: 200.ms,
                  begin: 0.06,
                  end: 0,
                  curve: Curves.easeOut,
                ),
          ),
        ),
      ),
    );
  }
}
