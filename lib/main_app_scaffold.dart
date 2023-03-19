import 'package:dragonator/router.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class MainAppScaffold extends StatefulWidget {
  final Widget body;

  MainAppScaffold({Key? key, required this.body}) : super(key: key);

  final List<NavigationTab> _bottomNavigationTabs = [
    NavigationTab(
      rootLocation: RoutePaths.roster,
      icon: Icons.people_outline_rounded,
      label: "Roster",
    ),
    NavigationTab(
      rootLocation: RoutePaths.races,
      icon: Icons.analytics_outlined,
      label: "Races",
    ),
    NavigationTab(
      rootLocation: RoutePaths.profile,
      icon: Icons.settings_rounded,
      label: "Settings",
    ),
  ];

  @override
  State<MainAppScaffold> createState() => _MainAppScaffoldState();
}

class _MainAppScaffoldState extends State<MainAppScaffold> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppColors.of(context).isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: DefaultTextStyle(
        //TODO: add correct color for text, because right now color of default text style is null.
        /*
         * Then hunt down anywhere text color is hardcoded or default text style is used,
         * and reference AppColors instead. This default text style should only be used
         * as the underlying default.
         */
        style: TextStyles.body1,
        // Use a Stack to allow the body to extend behind the navigation bar,
        // ensuring that each page's Scaffold is the full height of the screen.
        // Scaffolds that aren't the full height of the display cause errors,
        // such as adding padding to avoid on-screen keyboards incorrectly.
        // However, this workaround can cause issues since the app's body isn't
        // aware of the bottom navigation bar.
        // TODO: Fix this by making a Scaffold add the correct amount of padding to avoid the software keyboard.
        // See: https://github.com/flutter/flutter/issues/24768
        child: Stack(
          children: [
            widget.body,
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomNavigationBar(
                tabs: widget._bottomNavigationTabs,
                selectedRoutePath: GoRouter.of(context).location,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomNavigationBar extends StatelessWidget {
  final List<NavigationTab> tabs;
  final String selectedRoutePath;

  const CustomNavigationBar({
    Key? key,
    required this.tabs,
    required this.selectedRoutePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Container(
            height: 1,
            color: AppColors.of(context).smallSurface,
          ),
          const SizedBox(height: Insets.xs),
          SafeArea(
            top: false,
            minimum: const EdgeInsets.symmetric(vertical: Insets.xs),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var tab in tabs)
                  Expanded(
                    child: NavigationBarButton(
                      icon: tab.icon,
                      label: tab.label,
                      isActive: selectedRoutePath.startsWith(tab.rootLocation),
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
  late final _scaleAnimation =
      Tween<double>(begin: 1.5, end: 1).animate(_controller);

  final double _iconSize = 24;

  @override
  void initState() {
    if (widget.isActive) {
      // If the button is not active, begin with the selector faded out.
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
    final Widget activeTabHighlight = Transform(
      transform: Matrix4.skewX(0.35),
      alignment: Alignment.center,
      child: Container(
        width: 1.1 * _iconSize,
        height: 1.1 * _iconSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.of(context).accent.withOpacity(0.2),
        ),
      ),
    );

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Positioned.fill(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: activeTabHighlight,
                  ),
                ),
              ),
              Icon(widget.icon, size: _iconSize),
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
