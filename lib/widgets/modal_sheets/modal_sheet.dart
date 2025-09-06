import 'package:dragonator/styles/styles.dart';
import 'package:flutter/material.dart';

class ModalSheet extends StatelessWidget {
  final Widget child;

  const ModalSheet({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: TextStyles.body1.copyWith(fontWeight: FontWeight.w600),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: Navigator.of(context).pop,
              behavior: HitTestBehavior.opaque,
              child: Column(
                children: [
                  const _ModalSheetHandle(),
                  const SizedBox(
                    height: Insets.sm,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
            Flexible(
              child: Container(
                margin: const EdgeInsets.only(
                  left: Insets.sm,
                  right: Insets.sm,
                  bottom: Insets.sm,
                ),
                // Add clipping to maintain rounded corners if the child does
                // not have rounded corners. This is the case when using a
                // ModalNavigator, since PopupTransitionPage adds a background
                // to obscure the previous route during the push animation.
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
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
  const _ModalSheetHandle();

  @override
  State<_ModalSheetHandle> createState() => _ModalSheetHandleState();
}

class _ModalSheetHandleState extends State<_ModalSheetHandle>
    with SingleTickerProviderStateMixin {
  final _handelHeight = Insets.xs;
  final double _collapsedHandleWidth = 35;
  final double _expandedHandleWidth = 50;
  late Animation<double> _routeAnimation;
  bool _isExpanded = false;

  @override
  void didChangeDependencies() {
    // dependOnInheritedWidgetOfExactType cannot be called in initState. It is
    //safe to call in didChangeDependencies, which is called immediately after
    // initState.
    _routeAnimation = ModalRoute.of(context)!.animation!;
    _routeAnimation.addListener(() => updateHandle(_routeAnimation));
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _routeAnimation.removeListener(() => updateHandle(_routeAnimation));
    super.dispose();
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
