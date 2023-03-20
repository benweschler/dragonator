import 'dart:async';

import 'package:dragonator/main_app_scaffold.dart';
import 'package:dragonator/screens/edit_player_screen/edit_player_screen.dart';
import 'package:dragonator/screens/login_screen/login_screen.dart';
import 'package:dragonator/screens/signup_screen/signup_screen.dart';
import 'package:dragonator/screens/player_screen/player_screen.dart';
import 'package:dragonator/screens/roster_screen/roster_screen.dart';
import 'package:dragonator/screens/settings_screen.dart';
import 'package:dragonator/screens/races_screen.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

//TODO: UNCOMMENTING THIS WILL CRASH THE DART COMPILER
//TODO: adding <T> generic may fix crash
//typedef AppPage = CupertinoPage;

//TODO: consider using go_router_builder for strongly-typed routing.
abstract class RoutePaths {
  static String splash = '/';
  static String roster = '/roster';
  static String races = '/races';
  static String profile = '/profile';
  static String login = '/logIn';
  static String signUp = '/signUp';

  static String player(String id) => '/roster/player/$id';

  static String editPlayer({String? playerID, String? teamID}) =>
      _appendQueryParams(
        '/roster/edit-player',
        {'playerID': playerID, 'teamID': teamID},
      );
}

class AppRouter {
  final _rootNavigatorKey = GlobalKey<NavigatorState>();
  final _navBarNavigatorKey = GlobalKey<NavigatorState>();

  GoRouter get router {
    return GoRouter(
      initialLocation: RoutePaths.roster,
      navigatorKey: _rootNavigatorKey,
      refreshListenable: GoRouterRefreshStream(
        FirebaseAuth.instance.authStateChanges(),
      ),
      redirect: redirectNavigation,
      routes: [
        AppRoute(
          path: RoutePaths.login,
          isNavBarTab: true,
          builder: (_) => const LoginScreen(),
        ),
        AppRoute(
          path: RoutePaths.signUp,
          isNavBarTab: true,
          builder: (_) => SignUpScreen(),
        ),
        ShellRoute(
          navigatorKey: _navBarNavigatorKey,
          pageBuilder: (_, __, child) => NoTransitionPage(
            child: MainAppScaffold(body: child),
          ),
          routes: [
            AppRoute(
              path: RoutePaths.roster,
              builder: (_) => const RosterScreen(),
              isNavBarTab: true,
              routes: [
                AppRoute(
                  path: 'player/:id',
                  builder: (state) => PlayerScreen(state.params['id']!),
                ),
                AppRoute(
                  path: 'edit-player',
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

  String? redirectNavigation(BuildContext context, GoRouterState state) {
    if (FirebaseAuth.instance.currentUser == null &&
        state.subloc != RoutePaths.login &&
        state.subloc != RoutePaths.signUp) {
      return RoutePaths.login;
    } else if (FirebaseAuth.instance.currentUser != null &&
        state.subloc == RoutePaths.login) {
      return RoutePaths.roster;
    }

    return null;
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
        assert(
          !(pageBuilder != null && isNavBarTab),
          'Passing a pageBuilder causes isNavBarTab to have no effect. Offending route: $path.',
        ),
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
  path += '?';

  int index = 0;
  for (final entry in queryParams.entries) {
    if (entry.value == null) continue;
    path += '${entry.key}=${entry.value}';
    if (index < queryParams.length - 1) path += '&';
  }

  return path;
}

/// Converts a [Stream] to a [Listenable], which can then be passed as a
/// [refreshListenable] to a [GoRouter].
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
