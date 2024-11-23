import 'dart:async';

import 'package:dragonator/bootstrapper.dart';
import 'package:dragonator/main_app_scaffold.dart';
import 'package:dragonator/models/app_model.dart';
import 'package:dragonator/screens/lineups/edit_lineup/add_paddler_to_lineup_screen.dart';
import 'package:dragonator/screens/lineups/lineup_screen.dart';
import 'package:dragonator/screens/lineups/name_lineup_screen.dart';
import 'package:dragonator/screens/edit_paddler_screen/edit_paddler_screen.dart';
import 'package:dragonator/screens/forgot_password_screen.dart';
import 'package:dragonator/screens/lineups/edit_lineup/edit_lineup_screen.dart';
import 'package:dragonator/screens/login_screen/login_screen.dart';
import 'package:dragonator/screens/settings_screen/name_team_screen.dart';
import 'package:dragonator/screens/signup_screen/signup_screen.dart';
import 'package:dragonator/screens/paddler_screen/paddler_screen.dart';
import 'package:dragonator/screens/roster_screen/roster_screen.dart';
import 'package:dragonator/screens/settings_screen/settings_screen.dart';
import 'package:dragonator/screens/lineups/lineup_library_screen.dart';
import 'package:dragonator/screens/splash_screen.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/utils/notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'models/roster_model.dart';

typedef AppPage = CupertinoPage;

//TODO: consider using go_router_builder for strongly-typed routing.
abstract class RoutePaths {
  static String splash = '/';
  static String roster = '/roster';
  static String lineupLibrary = '/lineup-library';
  static String settings = '/settings';
  static String logIn = '/log-in';
  static String forgotPassword = '$logIn/forgot-password';
  static String signUp = '/sign-up';

  static String paddler(String id) => '/paddler/$id';

  static String editPaddler({String? paddlerID}) =>
      _appendQueryParams('$roster/edit-paddler', {'paddlerID': paddlerID});

  static String lineup(String lineupID) => '$lineupLibrary/lineup/$lineupID';

  /// If an ID is passed, the lineup is renamed. Otherwise, a lineup is created.
  static String nameLineup([String? lineupID]) => _appendQueryParams(
        '$lineupLibrary/name-lineup',
        {'lineupID': lineupID},
      );

  static String editLineup(String lineupID) =>
      '$lineupLibrary/lineup/$lineupID/edit-lineup/$lineupID';

  static String addPaddlerToLineup(String currentPath) =>
      '$currentPath/add-paddler';

  /// If an ID is passed, the team is renamed. Otherwise, a team is created.
  static String nameTeam([String? id]) =>
      _appendQueryParams('$settings/name-team', {if (id != null) 'id': id});
}

class AppRouter {
  final AppModel appModel;
  final _rootNavigatorKey = GlobalKey<NavigatorState>();
  final _navBarNavigatorKey = GlobalKey<NavigatorState>();

  AppRouter(this.appModel);

  GoRouter get router {
    return GoRouter(
      //TODO: get rid of initial location? redirect should handle this
      initialLocation: RoutePaths.roster,
      navigatorKey: _rootNavigatorKey,
      refreshListenable: appModel.routerRefreshNotifier,
      redirect: redirectNavigation,
      routes: [
        AppRoute(
          path: RoutePaths.splash,
          isNavBarTab: true,
          builder: (_) => const SplashScreen(),
        ),
        AppRoute(
          path: RoutePaths.logIn,
          isNavBarTab: true,
          builder: (_) => const LoginScreen(),
          routes: [
            AppRoute(
              path: 'forgot-password',
              builder: (_) => const ForgotPasswordScreen(),
            ),
          ],
        ),
        AppRoute(
          path: RoutePaths.signUp,
          builder: (_) => SignUpScreen(),
        ),
        ShellRoute(
          navigatorKey: _navBarNavigatorKey,
          pageBuilder: (_, __, child) => NoTransitionPage(
            child: MainAppScaffold(body: child),
          ),
          routes: [
            AppRoute(
              path: '/paddler/:id',
              builder: (state) => PaddlerScreen(state.pathParameters['id']!),
            ),
            AppRoute(
              path: RoutePaths.roster,
              builder: (_) => const RosterScreen(),
              isNavBarTab: true,
              routes: [
                AppRoute(
                  path: 'edit-paddler',
                  pageBuilder: (state) => FadeTransitionPage(
                    child: EditPaddlerScreen(
                      paddlerID: state.uri.queryParameters['paddlerID'],
                    ),
                  ),
                ),
              ],
            ),
            AppRoute(
              path: RoutePaths.lineupLibrary,
              isNavBarTab: true,
              builder: (_) => const LineupLibraryScreen(),
              routes: [
                AppRoute(
                  path: 'name-lineup',
                  pageBuilder: (state) => FadeTransitionPage(
                    child: NameLineupScreen(
                      lineupID: state.uri.queryParameters['lineupID'],
                    ),
                  ),
                ),
                AppRoute(
                  path: 'lineup/:id',
                  builder: (state) => LineupScreen(
                    lineupID: state.pathParameters['id']!,
                  ),
                  routes: [
                    AppRoute(
                      path: 'edit-lineup/:id',
                      pageBuilder: (state) => FadeTransitionPage(
                        child: EditLineupScreen(
                          lineupID: state.pathParameters['id']!,
                        ),
                      ),
                      routes: [
                        // TODO: navigating to paddler details goes to roster screen.
                        AppRoute(
                          path: 'add-paddler',
                          pageBuilder: (state) => FadeTransitionPage(
                            child: AddPaddlerToLineupScreen(
                              editedLineupPaddlers:
                                  (state.extra as Map)['editedLineupPaddlers'],
                              addPaddler: (state.extra as Map)['addPaddler'],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            AppRoute(
              path: RoutePaths.settings,
              isNavBarTab: true,
              builder: (_) => const SettingsScreen(),
              routes: [
                AppRoute(
                  path: 'name-team',
                  pageBuilder: (state) => FadeTransitionPage(
                    child: NameTeamScreen(
                      teamID: state.uri.queryParameters['id'],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  String? redirectNavigation(BuildContext context, GoRouterState state) {
    final path = state.matchedLocation;

    if (!appModel.isLoggedIn &&
        path != RoutePaths.logIn &&
        path != RoutePaths.signUp &&
        path != RoutePaths.forgotPassword) {
      //TODO: this should probably be put somewhere else.
      context.read<RosterModel>().clear();
      return RoutePaths.logIn;
    } else if (appModel.isLoggedIn) {
      if (!appModel.isInitialized && path != RoutePaths.splash) {
        Bootstrapper(
          appModel: appModel,
          rosterModel: context.read<RosterModel>(),
        ).initializeApp();
        return RoutePaths.splash;
      } else if (appModel.isInitialized && path == RoutePaths.splash) {
        return RoutePaths.roster;
      }
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
    required super.path,
    Widget Function(GoRouterState state)? builder,
    Page Function(GoRouterState state)? pageBuilder,
    List<GoRoute> super.routes = const [],
    super.parentNavigatorKey,
    this.isNavBarTab = false,
  })  : assert((builder == null) ^ (pageBuilder == null)),
        assert(
          !(pageBuilder != null && isNavBarTab),
          'Passing a pageBuilder causes isNavBarTab to have no effect. Offending route: $path.',
        ),
        super(
          pageBuilder: (context, state) {
            if (pageBuilder != null) return pageBuilder(state);

            if (isNavBarTab) {
              return NoTransitionPage(
                key: state.pageKey,
                child: builder!(state),
              );
            }

            return AppPage(child: builder!(state));
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
class GoRouterRefreshStream extends Notifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notify();
    _subscription = stream.asBroadcastStream().listen((_) => notify());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
