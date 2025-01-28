import 'package:dragonator/data/boat/boat.dart';
import 'package:dragonator/data/paddler/paddler.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:flutter/widgets.dart';

class COMOverlay extends ImplicitlyAnimatedWidget {
  final Offset com;
  final double topInset;
  final double bottomInset;
  final double leftAlignment;
  final double rightAlignment;

  const COMOverlay({
    super.key,
    required super.duration,
    required this.com,
    this.topInset = 0,
    this.bottomInset = 0,
    this.leftAlignment = 0,
    this.rightAlignment = 1,
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
            topInset: widget.topInset,
            bottomInset: widget.bottomInset,
            leftAlignment: widget.leftAlignment,
            rightAlignment: widget.rightAlignment,
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
  final double topInset;
  final double bottomInset;
  final double leftAlignment;
  final double rightAlignment;

  const _COMPainter({
    required this.com,
    required this.scrollOffset,
    required this.color,
    required this.topInset,
    required this.bottomInset,
    required this.leftAlignment,
    required this.rightAlignment,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final x = size.width * leftAlignment +
        (size.width * (rightAlignment - leftAlignment)) * com.dx;
    final y = (size.height - topInset - bottomInset) * com.dy + topInset;

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
          text: text, style: TextStyles.body2.copyWith(color: color)),
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

Offset calculateCOM({
  required Boat boat,
  required List<Paddler?> paddlerList,
}) {
  // The relative positions of the paddlers from the left edge of the boat.
  const relativeLeftXPos = 0;
  const relativeRightXPos = 1;
  final int numRows = (boat.capacity / 2).ceil() + 1;
  // The paddler is in the middle of its row, so count all rows up to this row
  // plus the first half of this row.
  double relativeYPos(int row) => (0.5 + row) / numRows;

  //The boat's COM is assumed to be at its center.
  // Masses weighted by their x-distance from the origin.
  double xWeighted = 0.5 * boat.weight;
  // Masses weighted by their y-distance from the origin.
  double yWeighted = 0.5 * boat.weight;
  // The total mass on the boat; boat weight + paddler weight.
  double total = boat.weight;

  for (int i = 0; i < boat.capacity; i++) {
    final paddler = paddlerList[i];
    if (paddler == null) continue;

    // The drummer and steers person sit along the midline of the boat.
    if (i == 0 || i == boat.capacity - 1) {
      xWeighted += paddler.weight * 0.5;
    }
    // Even indices are on the right, and odd indices are on the left.
    else if (i % 2 == 0) {
      xWeighted += paddler.weight * relativeRightXPos;
    } else {
      xWeighted += paddler.weight * relativeLeftXPos;
    }

    yWeighted += paddler.weight * relativeYPos((i / 2).ceil());
    total += paddler.weight;
  }

  // The COM should be in the middle of the boat if there are no paddlers added.
  if (total == 0) return Offset(0.5, 0.5);

  return Offset(xWeighted / total, yWeighted / total);
}
