import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//TODO: technically not widgets. maybe should go somewhere else than widgets folder?

// TODO: add documentation and make name better
/// For use in nested navigation inside of a [PopupDialog] with a
/// [ModalNavigator].
class PopupTransitionPage<T> extends CustomTransitionPage<T> {
  PopupTransitionPage({required super.child})
      : super(
          transitionDuration: Duration(milliseconds: 250),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        );
}

//TODO: unused
/// A wrapper around [DialogRoute] to allow for use in a [GoRouter].
class _DialogPage extends Page {
  final Widget child;
  final bool useSafeArea;

  const _DialogPage({
    this.useSafeArea = false,
    required this.child,
  });

  @override
  Route createRoute(BuildContext context) {
    return DialogRoute(
      context: context,
      settings: this,
      useSafeArea: useSafeArea,
      builder: (_) => child,
    );
  }
}
