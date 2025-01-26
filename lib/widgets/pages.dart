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
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: ColoredBox(
                // Add a background color to obscure the previous route during a push
                // animation.
                //TODO: this causes corner overflow
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                child: child,
              ),
            );
          },
        );
}
