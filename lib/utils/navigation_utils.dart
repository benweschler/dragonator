import 'package:dragonator/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension NavigationUtils on BuildContext {
  Future<T?> showModal<T>(Widget sheet) {
    return showModalBottomSheet<T>(
      context: this,
      // Removes shadow
      elevation: 0,
      backgroundColor: Colors.transparent,
      scrollControlDisabledMaxHeightRatio: 1,
      useRootNavigator: true,
      useSafeArea: true,
      builder: (_) => sheet,
    );
  }

  Future<T?> showPopup<T>(Widget popup, {bool barrierDismissible = true}) {
    return showDialog(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (_) => popup,
    );
  }

  /// Pops to the root page of the current path, and to the first root page of
  /// the app navigator if the current path's root isn't a root page.
  void popToRoot() {
    final currentPath = GoRouter.of(this).state!.uri;
    var rootPath = '/${currentPath.pathSegments.first}';
    if (!RoutePaths.rootPaths.contains(rootPath)) {
      rootPath = RoutePaths.rootPaths.first;
    }

    // Pop any modal sheets or popup dialogs
    Navigator.of(this, rootNavigator: true)
        .popUntil((route) => route.isFirst || route is! PopupRoute);

    GoRouter.of(this).go(rootPath);
  }
}
