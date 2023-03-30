import 'package:dragonator/styles/styles.dart';
import 'package:flutter/material.dart';

import 'animations/transitions.dart';

/// A scaffold that adds a [CustomAppBar] and screen border offsets to a screen.
class CustomScaffold extends StatelessWidget {
  final Widget? leading;
  final Widget? center;
  final Widget? trailing;
  final Widget? floatingActionButton;

  /// Whether the scaffold should horizontally inset its body from the edge of
  /// the display.
  final bool addScreenInset;

  final Widget child;

  const CustomScaffold({
    Key? key,
    this.leading,
    this.trailing,
    this.center,
    this.floatingActionButton,
    this.addScreenInset = true,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget body = SafeArea(
      bottom: false,
      minimum: addScreenInset
          ? const EdgeInsets.symmetric(horizontal: Insets.offset)
          : EdgeInsets.zero,
      child: child,
    );

    if (floatingActionButton != null) {
      body = Stack(
        children: [
          body,
          Positioned(
            bottom: Insets.lg,
            right: Insets.xl,
            child: floatingActionButton!,
          ),
        ],
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        leading: leading,
        center: center,
        trailing: trailing,
      ),
      body: body,
      // The Scaffold extends behind the app's bottom navigation bar, so add a
      // dummy nav bar to fill the space behind the real nav bar.
      //
      // Scaffolds that don't fill the entire screen incorrectly add bottom
      // padding to avoid the software keyboard, so this is done as a workaround
      // to ensure that the scaffold fills the screen.
      // TODO: Fix this by making a Scaffold add the correct amount of padding to avoid the software keyboard.
      bottomNavigationBar: const _DummyNavigationBar(),
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
      child: Hero(
        // Only animate between app bars scoped within the same Navigator.
        tag: Navigator.of(context),
        transitionOnUserGestures: true,
        flightShuttleBuilder: _shuttleBuilder,
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

  Widget _shuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return CrossFadeTransition(
      animation: flightDirection == HeroFlightDirection.push
          ? animation
          : ReverseAnimation(animation),
      //TODO: these DefaultTextStyles are required because heroes do not provide a default text style. Check status of this issue: https://github.com/flutter/flutter/issues/36220
      firstChild: DefaultTextStyle(
        style: DefaultTextStyle.of(fromHeroContext).style,
        child: fromHeroContext.widget,
      ),
      secondChild: DefaultTextStyle(
        style: DefaultTextStyle.of(toHeroContext).style,
        child: toHeroContext.widget,
      ),
    );
  }
}

class _DummyNavigationBar extends StatelessWidget {
  final double _navBarHeight = 59;

  const _DummyNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).viewPadding.bottom + _navBarHeight,
    );
  }
}
