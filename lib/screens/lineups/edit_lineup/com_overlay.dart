import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
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
    // The scroll position is used to keep the COM x-position text in view at
    // the top of the view port.
    final position = Scrollable.of(context).position;
    return AnimatedBuilder(
      animation: Listenable.merge([_comAnimation, position]),
      builder: (_, __) {
        return CustomPaint(
          painter: _COMPainter(
            com: _comAnimation.value,
            scrollOffset: position.pixels,
            color: AppColors.of(context).onBackground,
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
  final double scrollOffset;
  final Color color;
  final double headerInset;
  final double footerInset;

  const _COMPainter({
    required this.com,
    required this.scrollOffset,
    required this.color,
    required this.headerInset,
    required this.footerInset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final x = size.width * com.dx;
    final y = (size.height - headerInset - footerInset) * com.dy + headerInset;

    final paint = Paint()
      ..color = color
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

    final textPadding = 5.0;
    getTextPainter(String text) => TextPainter(
          text: TextSpan(
            text: text,
            style: TextStyles.body2.copyWith(color: color)
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );

    // COM x-position
    var tp = getTextPainter('${(com.dx * 100).round()}%');
    tp.layout();
    // Keep the text at the top of the viewport as the parent reorderable grid
    // scrolls.
    tp.paint(canvas, Offset(x + 10, scrollOffset));

    // COM y-position
    tp = getTextPainter('${(com.dy * 100).round()}%');
    tp.layout();
    tp.paint(canvas, Offset(textPadding, y - tp.height - textPadding));
  }

  @override
  bool shouldRepaint(_COMPainter oldDelegate) => oldDelegate.com != com;
}
