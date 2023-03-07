import 'package:dragonator/main_app_scaffold.dart';
import 'package:dragonator/screens/players_screen.dart';
import 'package:dragonator/screens/profile_screen.dart';
import 'package:dragonator/screens/races_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

// UNCOMMENTING THIS WILL CRASH THE DART COMPILER
//typedef AppPage = CupertinoPage;

abstract class ScreenPaths {
  static String splash = '/';
  static String players = '/players';
  static String races = '/races';
  static String profile = '/profile';
}

class AppRouter {
  final _rootNavigatorKey = GlobalKey<NavigatorState>();
  final _navBarNavigatorKey = GlobalKey<NavigatorState>();

  GoRouter get router => GoRouter(
        //TODO: get rid of initialLocation?
        initialLocation: "/players",
        navigatorKey: _rootNavigatorKey,
        routes: [
          ShellRoute(
            navigatorKey: _navBarNavigatorKey,
            builder: (_, __, child) => MainAppScaffold(body: child),
            routes: [
              AppRoute(ScreenPaths.players, (_) => const PlayersScreen()),
              AppRoute(ScreenPaths.races, (_) => const RacesScreen()),
              AppRoute(ScreenPaths.profile, (_) => const ProfileScreen()),
            ],
          ),
        ],
      );
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
