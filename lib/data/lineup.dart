//TODO: freeze
class Lineup {
  final String id;
  final String name;
  final Iterable<String?> paddlerIDs;

  const Lineup({
    required this.id,
    required this.name,
    required this.paddlerIDs,
  });

  Lineup copyWith({
    String? id,
    String? name,
    Iterable<String?>? paddlerIDs,
  }) {
    return Lineup(
      id: id ?? this.id,
      name: name ?? this.name,
      paddlerIDs: paddlerIDs ?? this.paddlerIDs,
    );
  }

  @override
  String toString() {
    return 'Lineup($id, $name, $paddlerIDs)';
  }
}
