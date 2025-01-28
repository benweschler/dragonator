import 'dart:collection';

import 'package:dragonator/data/paddler/paddler.dart';
import 'package:dragonator/utils/notifier.dart';

class LineupHistory extends Notifier {
  List<UnmodifiableListView<Paddler?>> _paddlerListHistory;
  List<UnmodifiableListView<Paddler?>> _cachedPops = [];

  LineupHistory({required List<Paddler?> initial})
      : _paddlerListHistory = [UnmodifiableListView(initial)];

  void push(List<Paddler?> element) {
    _paddlerListHistory.add(UnmodifiableListView(element));
    _cachedPops = [];
    notifyListeners();
  }

  void undo() {
    if(_paddlerListHistory.length <= 1) return;
    _cachedPops.add(_paddlerListHistory.removeLast());
    notifyListeners();
  }

  void redo() {
    if (_cachedPops.isEmpty) return;
    _paddlerListHistory.add((_cachedPops.removeLast()));
    notifyListeners();
  }

  void set(int index, Paddler? paddler) {
    final paddlerList = current;
    paddlerList[index] = paddler;
    push(paddlerList);
  }

  void flush(List<Paddler?> initialEntry) {
    _paddlerListHistory = [];
    push(initialEntry);
  }

  Paddler? at(int index) => _paddlerListHistory.last[index];

  List<Paddler?> get current => List.from(_paddlerListHistory.last);

  int get paddlerLength => _paddlerListHistory.last.length;

  bool get canUndo => _paddlerListHistory.length > 1;

  bool get canRedo => _cachedPops.isNotEmpty;
}
