import 'package:dragonator/styles/styles.dart';
import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final Widget? leading;
  final Widget? center;
  final Widget? trailing;
  final Widget child;

  const CustomScaffold({
    Key? key,
    this.leading,
    this.trailing,
    this.center,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        minimum: const EdgeInsets.symmetric(horizontal: Insets.offset),
        child: Column(
          children: [
            CustomAppBar(
              leading: leading,
              center: center,
              trailing: trailing,
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

/// An app bar with the option of a single leading element, a single center
/// element, and a single trailing element.
///
/// Automatically animates itself using a hero animation and cross-fade
/// transition across screens.
class CustomAppBar extends StatelessWidget {
  /// The leading widget shown in the app bar.
  final Widget? leading;

  /// The widget shown at the bottom of the app bar.
  final Widget? center;

  /// The trailing actions shown in the app bar.
  final Widget? trailing;

  const CustomAppBar({
    Key? key,
    this.leading,
    this.center,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Insets.med,
        horizontal: Insets.offset,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leading != null) leading!,
          if (center != null) Expanded(child: Center(child: center!)),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
