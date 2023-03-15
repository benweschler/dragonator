//TODO: isn't AgeGroup a team-level attribute?
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';

part 'player.freezed.dart';
part 'player.g.dart';

@Freezed(equal: false)
class Player extends Equatable with _$Player {
  const Player._();

  const factory Player({
    required String id,
    required String firstName,
    required String lastName,
    required int weight,
    required Gender gender,
    required SidePreference sidePreference,
    required String ageGroup,
    required bool drummerPreference,
    required bool steersPersonPreference,
    required bool strokePreference,
  }) = _Player;

  factory Player.fromJson(Map<String, Object?> json)
    => _$PlayerFromJson(json);

  @override
  List<Object?> get props => [id];
}

enum SidePreference {
  left,
  right;

  @override
  String toString() {
    switch (this) {
      case SidePreference.left:
        return "L";
      case SidePreference.right:
        return "R";
    }
  }
}

enum Gender {
  M,
  F,
  X;

  @override
  String toString() {
    switch (this) {
      case Gender.M:
        return "M";
      case Gender.F:
        return "F";
      case Gender.X:
        return "X";
    }
  }
}
