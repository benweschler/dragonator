import 'package:dragonator/styles/styles.dart';
import 'package:flutter/material.dart';

class ModalSheet extends StatelessWidget {
  final Color backgroundColor;
  final Widget child;

  const ModalSheet({
    Key? key,
    required this.backgroundColor,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _ModalSheetHandle(),
          const SizedBox(height: Insets.xs),
          Container(
            margin: const EdgeInsets.all(Insets.sm),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: Corners.medBorderRadius,
            ),
            child: child,
          ),
        ],
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
  bool _routeListenerAdded = false;
  bool _isExpanded = false;

  void updateHandle(Animation<double> routeAnimation) {
    if (routeAnimation.isCompleted) {
      setState(() => _isExpanded = true);
    } else if (!routeAnimation.isCompleted && _isExpanded) {
      setState(() => _isExpanded = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if(!_routeListenerAdded) {
      final routeAnimation = ModalRoute.of(context)!.animation!;
      routeAnimation.addListener(() => updateHandle(routeAnimation));
      _routeListenerAdded = true;
    }

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
