import 'package:dragonator/router.dart';
import 'package:dragonator/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

final List<NavigationTab> _bottomNavigationTabs = [
  NavigationTab(
    rootLocation: ScreenPaths.players,
    icon: Icons.rowing_rounded,
    label: "Players",
  ),
  NavigationTab(
    rootLocation: ScreenPaths.races,
    icon: Icons.analytics_rounded,
    label: "Races",
  ),
  NavigationTab(
    rootLocation: ScreenPaths.profile,
    icon: Icons.person_rounded,
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
      child: SafeArea(
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
    );
  }

  void _onItemTapped(BuildContext context, String rootLocation) {
    final location = GoRouter.of(context).location;
    if ((rootLocation != "/" || location == "/") &&
        location.startsWith(rootLocation)) return;
    context.go(rootLocation);
  }
}

class NavigationBarButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    //TODO: Don't hardcode grey opacity
    final buttonColor =
        IconTheme.of(context).color!.withOpacity(isActive ? 1 : 0.35);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: buttonColor, size: 28),
          Text(
            label,
            style: TextStyles.caption.copyWith(
              color: buttonColor,
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
