import 'package:flutter/material.dart';

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
}
