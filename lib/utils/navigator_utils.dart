import 'package:flutter/material.dart';

extension NavigatorUtils on BuildContext {
  Future<T?> showModal<T>(Widget sheet) {
    return showModalBottomSheet<T>(
      context: this,
      // Removes shadow
      elevation: 0,
      backgroundColor: Colors.transparent,
      scrollControlDisabledMaxHeightRatio: 1,
      builder: (_) => sheet,
      useRootNavigator: true,
    );
  }
}
