import 'package:dragonator/styles/styles.dart';
import 'package:flutter/material.dart';

class ModalSheet extends StatelessWidget {
  final Color backgroundColor;
  final Widget child;

  const ModalSheet({
    Key? key,
    required this.backgroundColor,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _ModalSheetHandle(),
          const SizedBox(height: Insets.xs),
          Container(
            margin: const EdgeInsets.all(Insets.sm),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: Corners.medBorderRadius,
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _ModalSheetHandle extends StatefulWidget {
  const _ModalSheetHandle({Key? key}) : super(key: key);

  @override
  State<_ModalSheetHandle> createState() => _ModalSheetHandleState();
}

class _ModalSheetHandleState extends State<_ModalSheetHandle>
    with SingleTickerProviderStateMixin {
  final _handelHeight = Insets.xs;
  late final _controller = AnimationController(
    duration: Timings.short,
    vsync: this,
  );
  late final _animation =
      Tween<double>(begin: 35, end: 50).animate(_controller);
  bool routeListenerAdded = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void updateHandle(Animation<double> routeAnimation) {
    if (routeAnimation.isCompleted) {
      _controller.forward();
    } else if (!routeAnimation.isCompleted && _controller.isCompleted) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    if(!routeListenerAdded) {
      final routeAnimation = ModalRoute.of(context)!.animation!;
      routeAnimation.addListener(() => updateHandle(routeAnimation));
      routeListenerAdded = true;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => Container(
        width: _animation.value,
        height: _handelHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_handelHeight),
        ),
      ),
    );
  }
}
