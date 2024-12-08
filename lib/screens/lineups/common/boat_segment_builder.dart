import 'dart:math' as math;

import 'package:dragonator/styles/theme.dart';
import 'package:flutter/widgets.dart';

import 'constants.dart';

Widget boatSegmentBuilder(BuildContext context, int index, int boatCapacity) {
  final CustomPainter painter;
  const maxBowIndex = kBoatEndExtent - 1;
  if (index < maxBowIndex || index > boatCapacity ~/ 2 - maxBowIndex) {
    return SizedBox.fromSize(size: const Size.fromHeight(kGridRowHeight));
  } else if (maxBowIndex < index &&
      index < boatCapacity ~/ 2 - maxBowIndex) {
    painter = _BoatSegmentPainter(
      rowNumber: index,
      outlineColor: AppColors.of(context).onBackground,
      fillColor: AppColors.of(context).largeSurface,
      segmentHeight: kGridRowHeight,
    );
  } else {
    painter = _BoatEndPainter(
      outlineColor: AppColors.of(context).onBackground,
      fillColor: AppColors.of(context).largeSurface,
      segmentHeight: kGridRowHeight,
      isBow: index == maxBowIndex,
      boatEndExtent: kBoatEndExtent,
      boatCapacity: boatCapacity,
    );
  }

  return SizedBox(
    width: double.infinity,
    height: kGridRowHeight,
    child: CustomPaint(painter: painter),
  );
}

class _BoatSegmentPainter extends CustomPainter {
  final int rowNumber;
  final Color outlineColor;
  final Color fillColor;
  final double segmentHeight;

  const _BoatSegmentPainter({
    required this.rowNumber,
    required this.outlineColor,
    required this.fillColor,
    required this.segmentHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double boatStrokeWidth = 3;
    final paint = Paint()
      ..color = outlineColor
      ..strokeWidth = boatStrokeWidth;

    final startLeft = Offset(size.width / 4, 0);
    final startRight = Offset(size.width * (3 / 4), 0);

    // Draw boat borders
    canvas.drawLine(startLeft, startLeft.translate(0, segmentHeight), paint);
    canvas.drawLine(startRight, startRight.translate(0, segmentHeight), paint);

    // Draw boat fill
    paint.color = fillColor;
    canvas.drawRect(
      Rect.fromPoints(
        startLeft.translate(boatStrokeWidth / 2, 0),
        startRight.translate(boatStrokeWidth / -2, segmentHeight),
      ),
      paint,
    );

    // Draw row text
    final rowText = _getRowTextPainter('$rowNumber', outlineColor);
    rowText.layout();
    rowText.paint(
      canvas,
      Offset(
        size.width / 2 - rowText.size.width / 2,
        size.height / 2 - rowText.size.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(_BoatSegmentPainter oldDelegate) => false;
}

class _BoatEndPainter extends CustomPainter {
  final Color outlineColor;
  final Color fillColor;
  final double segmentHeight;
  final bool isBow;
  final int boatEndExtent;
  final int boatCapacity;

  const _BoatEndPainter({
    required this.outlineColor,
    required this.fillColor,
    required this.segmentHeight,
    required this.isBow,
    required this.boatEndExtent,
    required this.boatCapacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 3;

    final strokePaint = Paint()
      ..color = outlineColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final fillPaint = Paint()..color = fillColor;

    // Draw left outline.
    canvas.drawArc(
      Rect.fromCircle(
        center: _getLeftCircleCenter(size.width),
        radius: _getRadius(size.width),
      ),
      math.pi,
      (isBow ? 1 : -1) * _getSweepAngle(size.width),
      false,
      strokePaint,
    );

    // Draw right outline.
    canvas.drawArc(
      Rect.fromCircle(
        center: _getRightCircleCenter(size.width),
        radius: _getRadius(size.width),
      ),
      0,
      (isBow ? -1 : 1) * _getSweepAngle(size.width),
      false,
      strokePaint,
    );

    // The delta from the base of a bow section to its tip.
    final intersectionDelta = Offset(
      0.25 * size.width,
      (isBow ? -1 : 1) * boatEndExtent * segmentHeight,
    );
    final fillPath = Path()
      ..moveTo(0.25 * size.width, isBow ? segmentHeight : 0)
      ..relativeArcToPoint(
        intersectionDelta,
        radius: Radius.circular(_getRadius(size.width)),
        clockwise: isBow,
      )
      ..relativeArcToPoint(
        Offset(intersectionDelta.dx, intersectionDelta.dy * -1),
        radius: Radius.circular(_getRadius(size.width)),
        clockwise: isBow,
      )
      ..close();

    // Draw fill.
    canvas.drawPath(fillPath, fillPaint);

    // Draw row text.
    //
    // The number of labeled rows is one less than the extent of the bow since
    // the drummer and steers person rows are unlabeled.
    for (int i = 0; i < boatEndExtent - 1; i++) {
      final label = isBow
          ? boatEndExtent - 1 - i
          : boatCapacity ~/ 2 - (boatEndExtent - 1) + i;
      final rowText = _getRowTextPainter('$label', outlineColor);

      rowText.layout();

      final heightIncrement = (isBow ? -1 : 1) * i * size.height;
      rowText.paint(
        canvas,
        Offset(
          size.width / 2 - rowText.size.width / 2,
          size.height / 2 - rowText.size.height / 2 + heightIncrement,
        ),
      );
    }
  }

  /*
  The following formulae are derived from solving for the equations of two
  circles that:
     * Are centered on the x-axis
     * Have equal radii
     * Intersect at (0.5, 1)
     * Have roots at x=0.25 and x=0.75
   These values are then scaled for the width and height of the segment.
   */

  Offset _getLeftCircleCenter(double w) {
    double h = segmentHeight;
    return Offset(
        0.375 * w + 2 * math.pow(h * boatEndExtent, 2) / w, isBow ? h : 0);
  }

  Offset _getRightCircleCenter(double w) {
    double h = segmentHeight;
    return Offset(
        0.625 * w - 2 * math.pow(h * boatEndExtent, 2) / w, isBow ? h : 0);
  }

  double _getRadius(double w) {
    double h = segmentHeight;
    return 0.125 * w + 2 * math.pow(h * boatEndExtent, 2) / w;
  }

  /// The sweep angle between the x-axis and the point of intersection.
  double _getSweepAngle(double w) {
    double h = segmentHeight;
    return math.atan(boatEndExtent *
        segmentHeight /
        (0.125 * w - 2 * math.pow(boatEndExtent * h, 2) / w).abs());
  }

  @override
  bool shouldRepaint(_BoatEndPainter oldDelegate) => false;
}

TextPainter _getRowTextPainter(String label, Color color) {
  return TextPainter(
    text: TextSpan(
      text: label,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    ),
    textDirection: TextDirection.ltr,
  );
}
