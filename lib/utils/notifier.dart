import 'package:flutter/foundation.dart';

/// Wraps ChangeNotifier.notifyListeners, adding a callback that reduces
/// boilerplate, similar to setState((){}) in a StatefulWidget. Also allows
/// external notifyListeners() calls, being un-opinionated about whether this is
/// called externally.
class Notifier extends ChangeNotifier {
  @override
  void notifyListeners([VoidCallback? action]) {
    action?.call();
    super.notifyListeners();
  }
}
