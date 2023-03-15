import 'package:dragonator/main_app_scaffold.dart';
import 'package:dragonator/screens/edit_player_screen/edit_player_screen.dart';
import 'package:dragonator/screens/player_screen/player_screen.dart';
import 'package:dragonator/screens/roster_screen/roster_screen.dart';
import 'package:dragonator/screens/settings_screen.dart';
import 'package:dragonator/screens/races_screen.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

//TODO: UNCOMMENTING THIS WILL CRASH THE DART COMPILER
//TODO: adding <T> generic may fix crash
//typedef AppPage = CupertinoPage;

abstract class RoutePaths {
  static String splash = '/';
  static String roster = '/roster';
  static String races = '/races';
  static String profile = '/profile';

  static String player(String id) => '/roster/player/$id';

  static String editPlayer({String? playerID, String? teamID}) =>
      _appendQueryParams(
        '/roster/edit-player',
        {"playerID": playerID, "teamID": teamID},
      );
}

class AppRouter {
  final _rootNavigatorKey = GlobalKey<NavigatorState>();
  final _navBarNavigatorKey = GlobalKey<NavigatorState>();

  GoRouter get router {
    return GoRouter(
      initialLocation: RoutePaths.roster,
      navigatorKey: _rootNavigatorKey,
      routes: [
        ShellRoute(
          navigatorKey: _navBarNavigatorKey,
          builder: (_, __, child) => MainAppScaffold(body: child),
          routes: [
            AppRoute(
              path: RoutePaths.roster,
              builder: (_) => RosterScreen(),
              isNavBarTab: true,
              routes: [
                AppRoute(
                  path: "player/:id",
                  builder: (state) => PlayerScreen(state.params['id']!),
                ),
                AppRoute(
                  path: "edit-player",
                  pageBuilder: (state) => FadeTransitionPage(
                    child: EditPlayerScreen(
                      playerID: state.queryParams['playerID'],
                      teamID: state.queryParams['teamID'],
                    ),
                  ),
                ),
              ],
            ),
            AppRoute(
              path: RoutePaths.races,
              isNavBarTab: true,
              builder: (_) => const RacesScreen(),
            ),
            AppRoute(
              path: RoutePaths.profile,
              isNavBarTab: true,
              builder: (_) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    );
  }
}

class FadeTransitionPage extends CustomTransitionPage {
  FadeTransitionPage({required super.child})
      : super(
          transitionDuration: Timings.short,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        );
}

/// Custom GoRoute sub-class to make the router declaration easier to read.
class AppRoute extends GoRoute {
  /// Whether this route is the root route of a nav bar tab.
  ///
  /// If it is, do not use a page transition animation, meaning that switching
  /// tabs is instant.
  final bool isNavBarTab;

  AppRoute({
    required String path,
    Widget Function(GoRouterState state)? builder,
    Page Function(GoRouterState state)? pageBuilder,
    List<GoRoute> routes = const [],
    this.isNavBarTab = false,
  })  : assert((builder == null) ^ (pageBuilder == null)),
        super(
          path: path,
          routes: routes,
          pageBuilder: (context, state) {
            if (pageBuilder != null) return pageBuilder(state);

            if (isNavBarTab) {
              return NoTransitionPage(
                key: state.pageKey,
                child: builder!(state),
              );
            }

            return CupertinoPage(child: builder!(state));
          },
        );
}

/// Appropriately appends to a route path in order to add [queryParams].
String _appendQueryParams(String path, Map<String, String?> queryParams) {
  if (queryParams.isEmpty) return path;
  path += "?";

  int index = 0;
  for (final entry in queryParams.entries) {
    if (entry.value == null) continue;
    path += "${entry.key}=${entry.value}";
    if (index < queryParams.length - 1) path += "&";
  }

  return path;
}
