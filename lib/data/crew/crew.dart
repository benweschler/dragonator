import 'package:dragonator/data/division/division.dart';
import 'package:dragonator/data/paddler/paddler.dart';

class Crew {
  final String id;
  final String name;
  final Set<Paddler> paddlers;
  final Division division;

  Crew({
    required this.id,
    required this.name,
    required this.paddlers,
    required this.division,
  });
}
