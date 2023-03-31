import 'package:dragonator/data/paddler.dart';

//TODO: freeze
class Lineup {
  final String id;
  final String name;
  final Iterable<Paddler?> paddlers;

  const Lineup({
    required this.id,
    required this.name,
    required this.paddlers,
  });

  Lineup copyWith({
    String? id,
    String? name,
    Iterable<Paddler?>? paddlers,
  }) {
    return Lineup(
      id: id ?? this.id,
      name: name ?? this.name,
      paddlers: paddlers ?? this.paddlers,
    );
  }
}
