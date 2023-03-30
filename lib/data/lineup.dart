import 'package:dragonator/data/paddler.dart';

//TODO: freeze
class Lineup {
  final String name;
  final Iterable<Paddler> paddlers;

  const Lineup({
    required this.name,
    required this.paddlers,
  });

  Lineup copyWith({
    required String? name,
    required Iterable<Paddler>? paddlers,
  }) {
    return Lineup(
      name: name ?? this.name,
      paddlers: paddlers ?? this.paddlers,
    );
  }
}
