import 'package:dragonator/styles/styles.dart';
import 'package:flutter/material.dart';

/// A [Navigator] meant to be used inside a modal window to implement nested
/// navigation. Animates between page sizes.
class ModalNavigator extends StatelessWidget {
  final String initialRoute;
  final Route Function(String? path) routeBuilder;

  const ModalNavigator({
    super.key,
    this.initialRoute = '/',
    required this.routeBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: Timings.long,
      curve: Curves.fastEaseInToSlowEaseOut,
      child: IntrinsicHeight(
        child: Navigator(
          initialRoute: initialRoute,
          observers: [HeroController()],
          onGenerateRoute: (settings) => routeBuilder(settings.name),
        ),
      ),
    );
  }
}
