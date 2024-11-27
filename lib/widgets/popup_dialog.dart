import 'package:dragonator/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PopupDialog extends StatelessWidget {
  final Widget child;

  const PopupDialog({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        child: Material(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: Corners.medBorderRadius,
          elevation: 15,
          child: Padding(
            padding: const EdgeInsets.all(Insets.lg),
            child: child,
          ),
        ).animate().slideY(
              // The the default duration of the transition animation in
              // showDialog
              duration: 200.ms,
              begin: 0.06,
              end: 0,
              curve: Curves.easeOut,
            ),
      ),
    );
  }
}
