import 'package:dragonator/data/lineup.dart';
import 'package:dragonator/data/paddler.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/screens/lineups/common/constants.dart';
import 'package:dragonator/screens/lineups/edit_lineup/add_paddler_tile.dart';
import 'package:dragonator/screens/lineups/edit_lineup/edit_lineup_options_modal_sheet.dart';
import 'package:dragonator/screens/lineups/edit_lineup/edit_paddler_tile.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/navigator_utils.dart';
import 'package:dragonator/widgets/buttons/custom_fab.dart';
import 'package:dragonator/widgets/buttons/custom_icon_button.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:animated_reorderable_grid/animated_reorderable_grid.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'boat_painters.dart';

//TODO: fix color theming in whole file!

class EditLineupScreen extends StatefulWidget {
  final String lineupID;

  const EditLineupScreen({super.key, required this.lineupID});

  @override
  State<EditLineupScreen> createState() => _EditLineupScreenState();
}

class _EditLineupScreenState extends State<EditLineupScreen> {
  late final Lineup _lineup;

  // This is mutable state. The paddler list is updated on reorder through set
  // state.
  late final List<Paddler?> _paddlerList;

  final _comVisibility = ValueNotifier(true);

  @override
  void initState() {
    super.initState();

    final rosterModel = context.read<RosterModel>();
    _lineup = rosterModel.getLineup(widget.lineupID)!;
    _paddlerList = [
      ..._lineup.paddlerIDs.map((id) => rosterModel.getPaddler(id)),
      for (int i = _lineup.paddlerIDs.length; i < kBoatCapacity; i++) null,
    ];
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final paddler = _paddlerList[index];
    if (paddler != null) {
      return EditPaddlerTile(
        paddlerID: paddler.id,
        index: index,
        removePaddler: () => setState(() => _paddlerList[index] = null),
      );
    }

    return AddPaddlerTile(
      //TODO: implement
      lineupID: widget.lineupID,
      addPaddler: (paddler) {
        if (paddler == null) return;
        setState(() => _paddlerList[index] = paddler);
      },
    );
  }

  Widget _rowBuilder(BuildContext context, int index) {
    final CustomPainter painter;
    const maxBowIndex = kBoatEndExtent - 1;
    if (index < maxBowIndex || index > kBoatCapacity ~/ 2 - maxBowIndex) {
      return SizedBox.fromSize(size: const Size.fromHeight(kGridRowHeight));
    } else if (maxBowIndex < index &&
        index < kBoatCapacity ~/ 2 - maxBowIndex) {
      painter = BoatSegmentPainter(
        rowNumber: index,
        //TODO: should be onBackground
        outlineColor: Colors.black,
        fillColor: AppColors.of(context).largeSurface,
        segmentHeight: kGridRowHeight,
      );
    } else {
      painter = BoatEndPainter(
        outlineColor: AppColors.of(context).primaryContainer,
        fillColor: AppColors.of(context).largeSurface,
        segmentHeight: kGridRowHeight,
        isBow: index == maxBowIndex,
        boatEndExtent: kBoatEndExtent,
        boatCapacity: kBoatCapacity,
      );
    }

    return SizedBox(
      width: double.infinity,
      height: kGridRowHeight,
      child: CustomPaint(painter: painter),
    );
  }

  Offset _calculateCOM() {
    const relativeLeftPos = 0.25;
    const relativeRightPos = 0.75;
    final int numRows = (kBoatCapacity / 2).ceil() + 1;
    double relativeYPos(int row) => (0.5 + row) / numRows;

    double xWeighted = 0;
    double yWeighted = 0;
    double total = 0;

    for (int i = 1; i < kBoatCapacity - 1; i++) {
      final paddler = _paddlerList[i];
      if (paddler == null) continue;

      // Even indices are on the right, and odd indices are on the left.
      if (i % 2 == 0) {
        xWeighted += paddler.weight * relativeRightPos;
      } else {
        xWeighted += paddler.weight * relativeLeftPos;
      }

      yWeighted += paddler.weight * relativeYPos((i / 2).ceil());
      total += paddler.weight;
    }

    if (_paddlerList.first != null) {
      // Add the drummer.
      total += _paddlerList.first!.weight;
      yWeighted += _paddlerList.first!.weight * relativeYPos(0);
      xWeighted += _paddlerList.first!.weight * 0.5;
    }
    if (_paddlerList.last != null) {
      // Add the steers person.
      total += _paddlerList.last!.weight;
      yWeighted += _paddlerList.last!.weight * relativeYPos(numRows - 1);
      xWeighted += _paddlerList.last!.weight * 0.5;
    }

    return Offset(xWeighted / total, yWeighted / total);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      addScreenInset: false,
      leading: CustomIconButton(
        onTap: context.pop,
        icon: Icons.close_rounded,
      ),
      center: Text('Edit ${_lineup.name}', style: TextStyles.title1),
      trailing: CustomIconButton(
        onTap: () {
          context.read<RosterModel>().setLineup(_lineup.copyWith(
                paddlerIDs: _paddlerList.map((paddler) => paddler?.id),
              ));
          context.pop();
        },
        icon: Icons.check_rounded,
      ),
      floatingActionButton: CustomFAB.extended(
        child: Text(
          'Options',
          style: TextStyles.title1.copyWith(
            color: AppColors.of(context).onPrimaryContainer,
          ),
        ),
        onTap: () => context.showModal(EditLineupOptionsModalSheet(
          com: _calculateCOM(),
          overlayVisibilityNotifier: _comVisibility,
          toggleOverlay: (value) => _comVisibility.value = value,
        )),
      ),
      //TODO: add an overlay wrapper inside of the reorderable grid implementation
      //TODO: add clipBehavior to reorderable grid
      child: AnimatedReorderableGrid(
        length: _paddlerList.length,
        crossAxisCount: 2,
        overriddenRowCounts: const [(0, 1), (kBoatCapacity ~/ 2, 1)],
        buildDefaultDragDetectors: false,
        itemBuilder: _itemBuilder,
        rowHeight: kGridRowHeight,
        rowBuilder: _rowBuilder,
        header: const SizedBox(height: Insets.med),
        footer: const SizedBox(height: Insets.med),
        overlay: ValueListenableBuilder(
          valueListenable: _comVisibility,
          builder: (_, visible, child) => Visibility(
            visible: visible,
            child: child!,
          ),
          child: _COMOverlay(
            duration: const Duration(milliseconds: 250),
            com: _calculateCOM(),
          ),
        ),
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

class _COMOverlay extends ImplicitlyAnimatedWidget {
  final Offset com;

  const _COMOverlay({required super.duration, required this.com})
      : super(curve: Curves.easeOutQuad);

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _COMOverlayState();
}

class _COMOverlayState extends ImplicitlyAnimatedWidgetState<_COMOverlay> {
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
          painter: _COMPainter(_comAnimation.value),
        );
      },
    );
  }
}

class _COMPainter extends CustomPainter {
  final Offset com;

  const _COMPainter(this.com);

  @override
  void paint(Canvas canvas, Size size) {
    final x = size.width * com.dx;
    final y = size.height * com.dy;

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
