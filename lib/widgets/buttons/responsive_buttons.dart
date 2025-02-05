import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:flutter/widgets.dart';

/// A button that plays a scale animation and exposes an animated overlay color,
/// both of which animate when the button is pressed.
///
/// In order to use the overlay color exposed by the [builder], composite it
/// with the color of your widget using
/// [Color.alphaBlend(overlayColor, yourColor)].
class ResponsiveButton extends StatefulWidget {
  final HitTestBehavior behavior;
  final GestureTapCallback? onTap;
  final Widget Function(Color overlayColor) builder;
  final double _scaleLowerBound;

  /// A button that adds a light overlay when tapped.
  const ResponsiveButton({
    super.key,
    this.behavior = HitTestBehavior.translucent,
    required this.onTap,
    required this.builder,
  })  : _scaleLowerBound = 0.85;

  /// A button that adds a light overlay when tapped.
  ///
  /// Uses a smaller shrinking animation, appropriate for large buttons.
  const ResponsiveButton.large({
    super.key,
    this.behavior = HitTestBehavior.translucent,
    required this.onTap,
    required this.builder,
  })  : _scaleLowerBound = 0.95;

  @override
  State<ResponsiveButton> createState() => _ResponsiveButtonState();
}

class _ResponsiveButtonState extends State<ResponsiveButton>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    duration: Timings.short,
    vsync: this,
  );
  late final _scaleAnimation = Tween<double>(
    begin: 1,
    end: widget._scaleLowerBound,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  /// True if the button is pressed and false if it is not pressed.
  bool pressedState = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Manages the button's pressing animation when it is pressed or unpressed.
  ///
  /// Always plays the forward pressing animation. If the button is still
  /// pressed when the forward animation completes, the animation stops.
  /// Otherwise, the animation reverses. If the button is pressed while the
  /// animation is reversing, it plays forward.
  void onPressed(bool isPressed) {
    //TODO: consider only calling onTap when the button's forward animation is completed
    if (isPressed) {
      pressedState = true;
      if (_controller.isDismissed ||
          _controller.status == AnimationStatus.reverse) {
        _controller.forward().then((_) {
          if (!pressedState) return _controller.reverse();
        });
      }
    } else if (!isPressed) {
      pressedState = false;
      if (_controller.isCompleted) {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final overlayColor = AppColors.of(context).responsiveOverlay;

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => ScaleTransition(
        scale: _scaleAnimation,
        child: _BaseResponsiveButton(
          behavior: widget.behavior,
          onTap: widget.onTap,
          onPressed: onPressed,
          child: widget.builder(
            Color.lerp(
              overlayColor.withValues(alpha: 0),
              overlayColor,
              _controller.value,
            )!,
          ),
        ),
      ),
    );
  }
}

/// A responsive button intended to be wrapped around a body made up of strokes,
/// namely an icon or text, rather than a solid body.
class ResponsiveStrokeButton extends StatefulWidget {
  final HitTestBehavior behavior;
  final GestureTapCallback onTap;
  final Widget child;

  const ResponsiveStrokeButton({
    super.key,
    this.behavior = HitTestBehavior.translucent,
    required this.onTap,
    required this.child,
  });

  @override
  State<ResponsiveStrokeButton> createState() => _ResponsiveStrokeButtonState();
}

class _ResponsiveStrokeButtonState extends State<ResponsiveStrokeButton>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    duration: Timings.med,
    vsync: this,
  );
  late final _opacityAnimation =
      Tween<double>(begin: 1, end: 0.33).animate(_controller);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => FadeTransition(
        opacity: _opacityAnimation,
        child: _BaseResponsiveButton(
          behavior: widget.behavior,
          onPressed: (isPressed) =>
              isPressed ? _controller.value = 1 : _controller.reverse(),
          onTap: widget.onTap,
          child: widget.child,
        ),
      ),
    );
  }
}

class _BaseResponsiveButton extends StatelessWidget {
  final HitTestBehavior behavior;
  final GestureTapCallback? onTap;
  final ValueChanged<bool> onPressed;
  final Widget child;

  const _BaseResponsiveButton({
    required this.behavior,
    required this.onTap,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: behavior,
      onTapDown: (_) => onPressed(true),
      onTapCancel: () => onPressed(false),
      onTapUp: (_) => onPressed(false),
      onTap: onTap,
      child: child,
    );
  }
}
