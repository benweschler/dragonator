import 'package:dragonator/data/boat/boat.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'team.freezed.dart';

part 'team.g.dart';

// Define equality only based on id using Equatable. This means that two Teams
// are equal if their ids are equal.
@Freezed(equal: false)
class Team extends Equatable with _$Team {
  const Team._();

  const factory Team({
    required String id,
    required String name,
    @_BoatMapConverter() required Map<String, Boat> boats,
  }) = _Team;

  factory Team.fromJson(Map<String, Object?> json) => _$TeamFromJson(json);

  factory Team.fromFirestore({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return Team.fromJson(data..['id'] = id);
  }

  static Map<String, dynamic> createFirestoreData({
    required String name,
    required String userID,
  }) {
    return {
      'name': name,
      'boats': {},
      'owners': [userID],
    };
  }

  @override
  List<Object?> get props => [id, name, boats];
}

class _BoatMapConverter
    implements JsonConverter<Map<String, Boat>, Map<String, dynamic>> {
  const _BoatMapConverter();

  @override
  Map<String, Boat> fromJson(Map<String, dynamic> json) {
    return {
      for (var boatEntry in json.entries)
        boatEntry.key: Boat.fromFirestore(
          id: boatEntry.key,
          data: boatEntry.value,
        )
    };
  }

  @override
  Map<String, dynamic> toJson(Map<String, Boat> boatMap) {
    return {
      for (var boatEntry in boatMap.entries)
        boatEntry.key: boatEntry.value.toFirestore()
    };
  }
}
