import 'dart:async';

import 'package:dragonator/main_app_scaffold.dart';
import 'package:dragonator/models/app_model.dart';
import 'package:dragonator/screens/edit_paddler_screen/edit_paddler_screen.dart';
import 'package:dragonator/screens/forgot_password_screen/forgot_password_screen.dart';
import 'package:dragonator/screens/login_screen/login_screen.dart';
import 'package:dragonator/screens/signup_screen/signup_screen.dart';
import 'package:dragonator/screens/paddler_screen/paddler_screen.dart';
import 'package:dragonator/screens/roster_screen/roster_screen.dart';
import 'package:dragonator/screens/settings_screen/settings_screen.dart';
import 'package:dragonator/screens/lineup_screen.dart';
import 'package:dragonator/screens/splash_screen.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

//TODO: UNCOMMENTING THIS WILL CRASH THE DART COMPILER
//TODO: adding <T> generic may fix crash
//typedef AppPage = CupertinoPage;

//TODO: consider using go_router_builder for strongly-typed routing.
abstract class RoutePaths {
  static String splash = '/';
  static String roster = '/roster';
  static String lineup = '/lineup';
  static String profile = '/profile';
  static String logIn = '/log-in';
  static String forgotPassword = '$logIn/forgot-password';
  static String signUp = '/sign-up';

  static String paddler(String id) => '$roster/paddler/$id';

  static String editPaddler({String? paddlerID, String? teamID}) =>
      _appendQueryParams(
        '$roster/edit-paddler',
        {'paddlerID': paddlerID, 'teamID': teamID},
      );
}

class AppRouter {
  final AppModel appModel;
  final _rootNavigatorKey = GlobalKey<NavigatorState>();
  final _navBarNavigatorKey = GlobalKey<NavigatorState>();

  AppRouter(this.appModel);

  GoRouter get router {
    return GoRouter(
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
              path: RoutePaths.roster,
              builder: (_) => const RosterScreen(),
              isNavBarTab: true,
              routes: [
                AppRoute(
                  path: 'paddler/:id',
                  builder: (state) => PaddlerScreen(state.params['id']!),
                ),
                AppRoute(
                  path: 'edit-paddler',
                  pageBuilder: (state) => FadeTransitionPage(
                    child: EditPaddlerScreen(
                      paddlerID: state.queryParams['paddlerID'],
                      teamID: state.queryParams['teamID'],
                    ),
                  ),
                ),
              ],
            ),
            AppRoute(
              path: RoutePaths.lineup,
              isNavBarTab: true,
              builder: (_) => const LineupScreen(),
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
    final path = state.subloc;

    if (!appModel.isLoggedIn &&
        path != RoutePaths.logIn &&
        path != RoutePaths.signUp &&
        path != RoutePaths.forgotPassword) {
      return RoutePaths.logIn;
    } else if (appModel.isLoggedIn) {
      if (!appModel.isInitialized && path != RoutePaths.splash) {
        appModel.initializeApp();
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
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
