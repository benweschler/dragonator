import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/widgets/buttons/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A scaffold that adds a [CustomAppBar] and screen border offsets to a screen.
class CustomScaffold extends StatelessWidget {
  final Widget? leading;
  final Widget? center;
  final Widget? trailing;
  final Widget child;

  /// Whether to automatically populate the [leading] widget with a
  /// [CustomBackButton] if no other leading widget is provided and the page can
  /// pop.
  ///
  /// Defaults to true.
  final bool automaticallyImplyBackButton;

  const CustomScaffold({
    Key? key,
    this.leading,
    this.trailing,
    this.center,
    this.automaticallyImplyBackButton = true,
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
              leading: automaticallyImplyBackButton &&
                      leading == null &&
                      context.canPop()
                  ? const CustomBackButton()
                  : leading,
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
      padding: const EdgeInsets.symmetric(vertical: Insets.sm),
      // Use a stack to ensure that the center widget is always centered on the
      // screen, regardless of whether a leading or trailing widget is provided.
      //
      // NavigationToolbar is a prebuilt widget that lays out an app bar, but it
      // uses CustomMultiChildLayout and so cannot have a dynamic height that
      // wraps its children.
      child: Stack(
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
    );
  }
}
