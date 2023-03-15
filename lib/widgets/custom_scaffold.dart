import 'package:dragonator/styles/styles.dart';
import 'package:flutter/material.dart';

import 'animations/transitions.dart';

/// A scaffold that adds a [CustomAppBar] and screen border offsets to a screen.
class CustomScaffold extends StatelessWidget {
  final Widget? leading;
  final Widget? center;
  final Widget? trailing;
  final Widget? floatingActionButton;
  final Widget child;

  const CustomScaffold({
    Key? key,
    this.leading,
    this.trailing,
    this.center,
    this.floatingActionButton,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget body = SafeArea(
      bottom: false,
      minimum: const EdgeInsets.symmetric(horizontal: Insets.offset),
      child: child,
    );

    if(floatingActionButton != null) {
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
