import 'package:dragonator/styles/styles.dart';
import 'package:flutter/material.dart';

/// A scaffold that adds a [CustomAppBar] and screen border offsets to a screen.
class CustomScaffold extends StatelessWidget {
  final Widget? leading;
  final Widget? center;
  final Widget? trailing;
  final Widget child;

  const CustomScaffold({
    Key? key,
    this.leading,
    this.trailing,
    this.center, required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: leading,
        center: center,
        trailing: trailing,
      ),
      body: SafeArea(
        bottom: false,
        minimum: const EdgeInsets.symmetric(horizontal: Insets.offset),
        child: child,
      ),
    );
  }
}

/// An app bar with the option of a single leading element, a single center
/// element, and a single trailing element.
///
/// Automatically animates itself using a hero animation and cross-fade
/// transition across screens.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
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
  Size get preferredSize => const Size.fromHeight(40);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.symmetric(horizontal: Insets.offset),
      // We need to add padding below the SafeArea in order to add a top inset
      // from the bottom of the upper safe area inset.
      child: Padding(
        padding: const EdgeInsets.symmetric(),
        // Use a stack to ensure that the center widget is always centered on the
        // screen, regardless of whether a leading or trailing widget is provided.
        //
        // NavigationToolbar is a prebuilt widget that lays out an app bar, but it
        // uses CustomMultiChildLayout and so cannot have a dynamic height that
        // wraps its children.
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (center != null) Center(child: center!),
            Row(
              children: [
                if (leading != null) leading!,
                const Spacer(),
                if (trailing != null) trailing!,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
