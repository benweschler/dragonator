import 'package:flutter/foundation.dart';

/// Wraps ChangeNotifier, adding a notify() method that reduces boilerplate,
/// similar to setState((){}) in a StatefulWidget. Also allows external
/// .notify() calls, being un-opinionated about whether this is called
/// externally.
class EasyNotifier extends ChangeNotifier {
  void notify([VoidCallback? action]) {
    action?.call();
    notifyListeners();
  }
}
