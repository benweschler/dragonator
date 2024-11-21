import 'package:flutter/material.dart';

class COMOverlay extends ImplicitlyAnimatedWidget {
  final Offset com;
  final double headerInset;
  final double footerInset;

  const COMOverlay({
    super.key,
    required super.duration,
    required this.com,
    this.headerInset = 0,
    this.footerInset = 0,
  }) : super(curve: Curves.easeOutQuad);

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _COMOverlayState();
}

class _COMOverlayState extends ImplicitlyAnimatedWidgetState<COMOverlay> {
  Tween<Offset>? _com;
  late Animation<Offset> _comAnimation;

  Tween<Offset> _tweenConstructor(dynamic value) {
    return Tween<Offset>(begin: value as Offset);
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _com = visitor(_com, widget.com, _tweenConstructor) as Tween<Offset>?;
  }

  @override
  void didUpdateTweens() {
    _comAnimation = animation.drive(_com!);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _comAnimation,
      builder: (_, __) {
        return CustomPaint(
          painter: _COMPainter(
            com: _comAnimation.value,
            headerInset: widget.headerInset,
            footerInset: widget.footerInset,
          ),
        );
      },
    );
  }
}

class _COMPainter extends CustomPainter {
  final Offset com;
  final double headerInset;
  final double footerInset;

  const _COMPainter({
    required this.com,
    required this.headerInset,
    required this.footerInset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final x = size.width * com.dx;
    final y = (size.height - headerInset - footerInset) * com.dy + headerInset;

    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    const double targetRadius = 20;
    canvas.drawCircle(Offset(x, y), targetRadius, paint);
    canvas.drawLine(Offset(x, 0), Offset(x, y - targetRadius * 0.6), paint);
    canvas.drawLine(
      Offset(x, size.height),
      Offset(x, y + targetRadius * 0.6),
      paint,
    );
    canvas.drawLine(Offset(0, y), Offset(x - targetRadius * 0.6, y), paint);
    canvas.drawLine(
      Offset(size.width, y),
      Offset(x + targetRadius * 0.6, y),
      paint,
    );
  }

  @override
  bool shouldRepaint(_COMPainter oldDelegate) => oldDelegate.com != com;
}