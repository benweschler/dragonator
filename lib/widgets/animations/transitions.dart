import 'package:flutter/material.dart';

class CrossFadeTransition extends AnimatedWidget {
  final Animation<double> animation;
  final Widget firstChild;
  final Widget secondChild;

  const CrossFadeTransition({
    super.key,
    required this.animation,
    required this.firstChild,
    required this.secondChild,
  }) : super(listenable: animation);

  static final _quadraticValleyTween = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween<double>(begin: 1, end: 0)
          .chain(CurveTween(curve: Curves.easeOut)),
      weight: 0.5,
    ),
    TweenSequenceItem(
      tween: Tween<double>(begin: 0, end: 1)
          .chain(CurveTween(curve: Curves.easeIn)),
      weight: 0.5,
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _quadraticValleyTween.animate(animation),
      child: animation.value <= 0.5 ? firstChild : secondChild,
    );
  }
}
