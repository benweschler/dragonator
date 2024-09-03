import 'dart:io';
import 'dart:math' as math;

import 'package:dragonator/data/lineup.dart';
import 'package:dragonator/data/paddler.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/custom_icon_button.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:animated_reorderable_grid/animated_reorderable_grid.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

//TODO: fix color theming in whole file!
//TODO: tip and end of boat are cut off

const int _kBoatCapacity = 22;

/// The number of segments that the bow extends through.
const int _kBowExtent = 3;

class EditLineupScreen extends StatefulWidget {
  final String lineupID;

  const EditLineupScreen({super.key, required this.lineupID});

  @override
  State<EditLineupScreen> createState() => _EditLineupScreenState();
}

class _EditLineupScreenState extends State<EditLineupScreen> {
  late final Lineup _lineup =
      context.read<RosterModel>().getLineup(widget.lineupID)!;

  // This is mutable state. The paddler list is updated on reorder through set
  // state.
  late final List<Paddler?> _paddlerList = [
    ..._lineup.paddlers,
    for (int i = _lineup.paddlers.length; i < _kBoatCapacity; i++) null,
  ];

  @override
  Widget build(BuildContext context) {
    const double rowHeight = 100;

    return CustomScaffold(
      addScreenInset: false,
      leading: CustomIconButton(
        onTap: context.pop,
        icon: Icons.close_rounded,
      ),
      center: Text(_lineup.name, style: TextStyles.title1),
      trailing: CustomIconButton(
        onTap: () {
          context
              .read<RosterModel>()
              .setLineup(_lineup.copyWith(paddlers: _paddlerList));
          context.pop();
        },
        icon: Icons.check_rounded,
      ),
      child: AnimatedReorderableGrid(
        length: _paddlerList.length,
        crossAxisCount: 2,
        overriddenRowCounts: const [(0, 1), (_kBoatCapacity ~/ 2, 1)],
        buildDefaultDragDetectors: false,
        itemBuilder: (_, index) {
          final paddler = _paddlerList[index];
          if (paddler != null) {
            return _PaddlerTile(
              name: '${paddler.firstName} ${paddler.lastName}',
              index: index,
            );
          }

          return ReorderableGridDragListener(
            index: index,
            child: const _AddPaddlerTile(),
          );
        },
        rowHeight: rowHeight,
        rowBuilder: (context, index) {
          final CustomPainter painter;
          const bowIndex = _kBowExtent - 1;
          if (index < bowIndex || index > _kBoatCapacity ~/ 2 - bowIndex) {
            return SizedBox.fromSize(size: const Size.fromHeight(rowHeight));
          } else if (bowIndex < index &&
              index < _kBoatCapacity ~/ 2 - bowIndex) {
            painter = _BoatSegmentPainter(
              rowNumber: index,
              segmentHeight: rowHeight,
              boatColor: AppColors.of(context).largeSurface,
              //TODO: should be onBackground
              paintColor: Colors.black,
            );
          } else {
            painter = _BoatEndPainter(
              paintColor: AppColors.of(context).primaryContainer,
              segmentHeight: rowHeight,
              isBow: index == bowIndex,
            );
          }

          return SizedBox(
            width: double.infinity,
            height: rowHeight,
            child: CustomPaint(painter: painter),
          );
        },
        keyBuilder: (index) => ValueKey(index),
        onReorder: (oldIndex, newIndex) => setState(() {
          final temp = _paddlerList[oldIndex];
          _paddlerList[oldIndex] = _paddlerList[newIndex];
          _paddlerList[newIndex] = temp;
        }),
      ),
    );
  }
}

class _BoatSegmentPainter extends CustomPainter {
  final int rowNumber;
  final Color paintColor;
  final Color boatColor;
  final double segmentHeight;

  const _BoatSegmentPainter({
    required this.rowNumber,
    required this.paintColor,
    required this.boatColor,
    required this.segmentHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double boatStrokeWidth = 3;
    final paint = Paint()
      ..color = paintColor
      ..strokeWidth = boatStrokeWidth;

    final startLeft = Offset(size.width / 4, 0);
    final startRight = Offset(size.width * (3 / 4), 0);

    // Draw boat borders
    canvas.drawLine(startLeft, startLeft.translate(0, segmentHeight), paint);
    canvas.drawLine(startRight, startRight.translate(0, segmentHeight), paint);

    // Draw boat fill
    paint.color = boatColor;
    canvas.drawRect(
      Rect.fromPoints(
        startLeft.translate(boatStrokeWidth / 2, 0),
        startRight.translate(boatStrokeWidth / -2, segmentHeight),
      ),
      paint,
    );

    // Draw row text
    final rowText = TextPainter(
      text: TextSpan(
        text: '$rowNumber',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: paintColor,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

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
  final Color paintColor;
  final double segmentHeight;
  final bool isBow;

  const _BoatEndPainter({
    required this.paintColor,
    required this.segmentHeight,
    required this.isBow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 3;

    final paint = Paint()
      ..color = paintColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    // Draw left circle
    canvas.drawArc(
      Rect.fromCircle(
        center: _getLeftCircleCenter(size.width),
        radius: _getRadius(size.width),
      ),
      math.pi,
      (isBow ? 1 : -1) * _getSweepAngle(size.width),
      false,
      paint,
    );

    // Draw right circle
    canvas.drawArc(
      Rect.fromCircle(
        center: _getRightCircleCenter(size.width),
        radius: _getRadius(size.width),
      ),
      0,
      (isBow ? -1 : 1) * _getSweepAngle(size.width),
      false,
      paint,
    );
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
        0.375 * w + 2 * math.pow(h * _kBowExtent, 2) / w, isBow ? h : 0);
  }

  Offset _getRightCircleCenter(double w) {
    double h = segmentHeight;
    return Offset(
        0.625 * w - 2 * math.pow(h * _kBowExtent, 2) / w, isBow ? h : 0);
  }

  double _getRadius(double w) {
    double h = segmentHeight;
    return 0.125 * w + 2 * math.pow(h * _kBowExtent, 2) / w;
  }

  /// The sweep angle between the x-axis and the point of intersection.
  double _getSweepAngle(double w) {
    double h = segmentHeight;
    return math.atan(_kBowExtent *
        segmentHeight /
        (0.125 * w - 2 * math.pow(_kBowExtent * h, 2) / w).abs());
  }

  @override
  bool shouldRepaint(_BoatEndPainter oldDelegate) => false;
}

class _PaddlerTile extends StatelessWidget {
  final String name;
  final int index;

  const _PaddlerTile({required this.name, required this.index});

  @override
  Widget build(BuildContext context) {
    final moreIcon = Platform.isAndroid ? Icons.more_vert : Icons.more_horiz;

    // The CustomSingleChildLayout needs to take on the width and height of
    // the tile.
    return IntrinsicHeight(
      child: IntrinsicWidth(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ReorderableGridDragListener(
              index: index,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 0.4 * MediaQuery.of(context).size.width,
                ),
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  borderRadius: Corners.smBorderRadius,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border.all(color: AppColors.of(context).primaryContainer),
                ),
                child: Text(
                  name,
                  style: TextStyles.body1.copyWith(
                    color: AppColors.of(context).primaryContainer,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => print('tap'),
              child: CustomSingleChildLayout(
                delegate: _PaddlerTileLayoutDelegate(),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.of(context).neutralContent),
                    color: Color.alphaBlend(
                      AppColors.of(context).smallSurface,
                      Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                  child: Icon(moreIcon, size: 16, color: AppColors.of(context).neutralContent,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaddlerTileLayoutDelegate extends SingleChildLayoutDelegate {
  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(
      size.width - childSize.width / 2,
      childSize.height / -2,
    );
  }

  @override
  bool shouldRelayout(_PaddlerTileLayoutDelegate oldDelegate) => false;
}

class _AddPaddlerTile extends StatelessWidget {
  const _AddPaddlerTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 0.4 * MediaQuery.of(context).size.width,
      ),
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          AppColors.of(context).errorSurface,
          Theme.of(context).scaffoldBackgroundColor,
        ),
        borderRadius: Corners.smBorderRadius,
        border: Border.all(color: AppColors.of(context).accent),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add',
            style: TextStyles.body1.copyWith(
              color: AppColors.of(context).accent,
            ),
            maxLines: 2,
          ),
          const SizedBox(width: Insets.xs),
          Icon(Icons.add_rounded, color: AppColors.of(context).accent),
        ],
      ),
    );
  }
}
