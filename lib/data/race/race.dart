import 'package:dragonator/data/crew/crew.dart';

class Race {
  final String id;
  final String name;
  final Set<Crew> crews;

  Race({
    required this.id,
    required this.name,
    required this.crews,
  });
}
