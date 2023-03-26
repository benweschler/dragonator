import 'package:dragonator/styles/styles.dart';
import 'package:flutter/material.dart';

class ModalSheet extends StatelessWidget {
  final Widget child;

  const ModalSheet({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: TextStyles.body1.copyWith(fontWeight: FontWeight.w600),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _ModalSheetHandle(),
            const SizedBox(height: Insets.xs),
            Flexible(
              child: Container(
                margin: const EdgeInsets.all(Insets.sm),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: Corners.medBorderRadius,
                ),
                child: child,
              ),
            ),
          ],
        ),
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
  final double _collapsedHandleWidth = 35;
  final double _expandedHandleWidth = 50;
  bool _isExpanded = false;

  @override
  void didChangeDependencies() {
    // dependOnInheritedWidgetOfExactType cannot be called in initState. It is
    //safe to call in didChangeDependencies, which is called immediately after
    // initState.
    final routeAnimation = ModalRoute.of(context)!.animation!;
    routeAnimation.addListener(() => updateHandle(routeAnimation));
    super.didChangeDependencies();
  }

  void updateHandle(Animation<double> routeAnimation) {
    if (routeAnimation.isCompleted) {
      setState(() => _isExpanded = true);
    } else if (!routeAnimation.isCompleted && _isExpanded) {
      setState(() => _isExpanded = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Timings.short,
      width: _isExpanded ? _expandedHandleWidth : _collapsedHandleWidth,
      height: _handelHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_handelHeight),
      ),
    );
  }
}
