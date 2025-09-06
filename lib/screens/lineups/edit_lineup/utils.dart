import 'package:dragonator/data/boat/boat.dart';
import 'package:dragonator/data/paddler/paddler.dart';

SidePreference? calculateSide(int index, Boat boat) {
  if(index == 0 || index == boat.capacity - 1) return null;
  return index % 2 == 0 ? SidePreference.right : SidePreference.left;
}

Position? calculatePosition(int index, Boat boat) {
  if (index == 0) return Position.drummer;
  if(index == boat.capacity - 1) return Position.steersPerson;
  if(index == 1 || index == 2) return Position.stroke;
  return null;
}

enum Position {
  drummer,
  steersPerson,
  stroke;

  bool _steersPersonFilter(Paddler paddler) => paddler.steersPersonPreference;

  bool _drummerFilter(Paddler paddler) => paddler.drummerPreference;

  bool _strokeFilter(Paddler paddler) => paddler.strokePreference;

  bool filter(Paddler paddler) {
    switch (this) {
      case drummer:
        return _drummerFilter(paddler);
      case steersPerson:
        return _steersPersonFilter(paddler);
      case stroke:
        return _strokeFilter(paddler);
    }
  }

  @override
  String toString() {
    switch (this) {
      case drummer:
        return 'Drummer';
      case steersPerson:
        return 'Steers Person';
      case stroke:
        return 'Stroke';
    }
  }
}
