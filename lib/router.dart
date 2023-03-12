import 'package:dragonator/main_app_scaffold.dart';
import 'package:dragonator/screens/player_screen.dart';
import 'package:dragonator/screens/roster_screen/roster_screen.dart';
import 'package:dragonator/screens/settings_screen.dart';
import 'package:dragonator/screens/races_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

//TODO: UNCOMMENTING THIS WILL CRASH THE DART COMPILER
//TODO: adding <T> generic may fix crash
//typedef AppPage = CupertinoPage;

abstract class ScreenPaths {
  static String splash = '/';
  static String roster = '/roster';
  static String races = '/races';
  static String profile = '/profile';
  static String player(String id) => '/roster/player/$id';
}

class AppRouter {
  final _rootNavigatorKey = GlobalKey<NavigatorState>();
  final _navBarNavigatorKey = GlobalKey<NavigatorState>();

  GoRouter get router {
    return GoRouter(
      initialLocation: ScreenPaths.roster,
      navigatorKey: _rootNavigatorKey,
      routes: [
        ShellRoute(
          navigatorKey: _navBarNavigatorKey,
          builder: (_, __, child) => MainAppScaffold(body: child),
          routes: [
            AppRoute(
              ScreenPaths.roster,
              (_) => RosterScreen(),
              routes: [
                AppRoute(
                  "player/:id",
                  (state) => PlayerScreen(state.params['id']!),
                ),
              ],
            ),
            AppRoute(ScreenPaths.races, (_) => const RacesScreen()),
            AppRoute(ScreenPaths.profile, (_) => const SettingsScreen()),
          ],
        ),
      ],
    );
  }
}

/// Custom GoRoute sub-class to make the router declaration easier to read.
class AppRoute extends GoRoute {
  /// Whether this route is the root route of a nav bar tab.
  ///
  /// If it is, do not use a page transition animation, meaning that switching
  /// tabs is instant.
  final bool isNavBarTab;

  AppRoute(
    String path,
    Widget Function(GoRouterState state) builder, {
    List<GoRoute> routes = const [],
    this.isNavBarTab = false,
  }) : super(
          path: path,
          routes: routes,
          pageBuilder: (context, state) {
            if (isNavBarTab) {
              return NoTransitionPage(
                key: state.pageKey,
                child: builder(state),
              );
            }
            return CupertinoPage(child: builder(state));
          },
        );
}
