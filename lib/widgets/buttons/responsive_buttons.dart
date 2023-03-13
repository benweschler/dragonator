import 'package:dragonator/styles/styles.dart';
import 'package:flutter/widgets.dart';

/// A button that plays a scale animation and exposes an animated overlay color,
/// both of which animate when the button is pressed.
///
/// In order to use the overlay color exposed by the [builder], composite it
/// with the color of your widget using
/// [Color.alphaBlend(overlayColor, yourColor)].
class ResponsiveButton extends StatefulWidget {
  final GestureTapCallback? onTap;
  final Widget Function(Color overlayColor) builder;
  final Color _overlayColor = const Color(0x80FFFFFF);

  /// A button that adds a light overlay when tapped.
  const ResponsiveButton({
    Key? key,
    required this.onTap,
    required this.builder,
  }) : super(key: key);

  @override
  State<ResponsiveButton> createState() => _ResponsiveButtonState();
}

class _ResponsiveButtonState extends State<ResponsiveButton>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    duration: Timings.short,
    vsync: this,
  );
  late final _scaleAnimation = Tween<double>(begin: 1, end: 0.8)
      .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

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
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => ScaleTransition(
        scale: _scaleAnimation,
        child: _BaseResponsiveButton(
          onTap: widget.onTap,
          onPressed: onPressed,
          child: widget.builder(
            Color.lerp(
              widget._overlayColor.withOpacity(0),
              widget._overlayColor,
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
  final GestureTapCallback onTap;
  final Widget child;

  const ResponsiveStrokeButton({
    Key? key,
    required this.onTap,
    required this.child,
  }) : super(key: key);

  @override
  State<ResponsiveStrokeButton> createState() => _ResponsiveStrokeButtonState();
}

class _ResponsiveStrokeButtonState extends State<ResponsiveStrokeButton>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    duration: Timings.short,
    vsync: this,
  );
  late final _opacityAnimation =
      Tween<double>(begin: 1, end: 0.5).animate(_controller);

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
  final GestureTapCallback? onTap;
  final ValueChanged<bool> onPressed;
  final Widget child;

  const _BaseResponsiveButton({
    Key? key,
    required this.onTap,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (_) => onPressed(true),
      onTapCancel: () => onPressed(false),
      onTapUp: (_) => onPressed(false),
      onTap: onTap,
      child: child,
    );
  }
}
