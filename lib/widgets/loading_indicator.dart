import 'package:flutter/widgets.dart';
import 'dart:math';

class LoadingIndicator extends StatefulWidget {
  final Color color;
  final Size? size;

  const LoadingIndicator(this.color, {Key? key, this.size}) : super(key: key);

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );
  late final _rotationAnimation = Tween<double>(
    begin: 0,
    end: 2 * pi,
  ).animate(_controller);

  @override
  void initState() {
    super.initState();
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (_, __) {
        return Transform.rotate(
          angle: _rotationAnimation.value,
          child: CustomPaint(
            painter: _LoadingIndicatorPainter(color: widget.color),
            size: widget.size ?? Size.zero,
          ),
        );
      },
    );
  }
}

class _LoadingIndicatorPainter extends CustomPainter {
  final Color color;

  const _LoadingIndicatorPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(Offset.zero & size, -pi / 2, 0.8 * 2 * pi, false, paint);
  }

  @override
  bool shouldRepaint(_LoadingIndicatorPainter oldDelegate) {
    return color != oldDelegate.color;
  }
}
