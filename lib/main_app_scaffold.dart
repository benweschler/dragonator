import 'package:dragonator/router.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

final List<NavigationTab> _bottomNavigationTabs = [
  NavigationTab(
    rootLocation: ScreenPaths.players,
    icon: Icons.rowing_sharp,
    label: "Players",
  ),
  NavigationTab(
    rootLocation: ScreenPaths.races,
    icon: Icons.analytics_sharp,
    label: "Races",
  ),
  NavigationTab(
    rootLocation: ScreenPaths.profile,
    icon: Icons.person_sharp,
    label: "Profile",
  ),
];

class MainAppScaffold extends StatefulWidget {
  final Widget body;

  const MainAppScaffold({Key? key, required this.body}) : super(key: key);

  @override
  State<MainAppScaffold> createState() => _MainAppScaffoldState();
}

class _MainAppScaffoldState extends State<MainAppScaffold> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: DefaultTextStyle(
        style: TextStyles.body2,
        child: Column(
          children: [
            Expanded(child: widget.body),
            // The navigation bar does not have a Scaffold, and therefore does not
            // have a DefaultTextStyle, as its ancestor, so provide one here.
            CustomNavigationBar(
              selectedRouteName: GoRouter.of(context).location,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomNavigationBar extends StatelessWidget {
  final String selectedRouteName;

  const CustomNavigationBar({
    Key? key,
    required this.selectedRouteName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: Insets.sm),
            height: 0.25,
          ),
          SafeArea(
            top: false,
            minimum: const EdgeInsets.only(top: Insets.xs),
            child: Row(
              children: [
                for (var tab in _bottomNavigationTabs)
                  Expanded(
                    child: NavigationBarButton(
                      icon: tab.icon,
                      label: tab.label,
                      isActive: tab.rootLocation == selectedRouteName,
                      onTap: () => _onItemTapped(context, tab.rootLocation),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(BuildContext context, String rootLocation) {
    if (rootLocation == GoRouter.of(context).location) return;
    HapticFeedback.lightImpact();
    context.go(rootLocation);
  }
}

class NavigationBarButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final GestureTapCallback onTap;

  const NavigationBarButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  State<NavigationBarButton> createState() => _NavigationBarButtonState();
}

class _NavigationBarButtonState extends State<NavigationBarButton>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    duration: Timings.short,
    vsync: this,
  );
  late final _fadeAnimation =
      Tween<double>(begin: 0, end: 1).animate(_controller);
  late final _positionAnimation =
      Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
          .animate(_controller);

  final double _iconSize = 28;

  @override
  void initState() {
    if (widget.isActive) {
      _controller.value = 1;
    }

    super.initState();
  }

  @override
  void didUpdateWidget(covariant NavigationBarButton oldWidget) {
    if (widget.isActive != oldWidget.isActive) {
      widget.isActive ? _controller.forward() : _controller.reverse();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _positionAnimation,
                  child: Container(
                    width: _iconSize + 2 * Insets.sm,
                    height: _iconSize + 2 * Insets.sm,
                    decoration: BoxDecoration(
                      borderRadius: Corners.medBorderRadius,
                      color: AppColors.of(context).neutralHighlight,
                    ),
                  ),
                ),
              ),
              Positioned.fill(child: Icon(widget.icon, size: _iconSize)),
            ],
          ),
          const SizedBox(height: Insets.xs),
          Text(
            widget.label,
            style: TextStyles.caption.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationTab {
  final String rootLocation;
  final IconData icon;
  final String label;

  const NavigationTab({
    required this.rootLocation,
    required this.icon,
    required this.label,
  });
}
