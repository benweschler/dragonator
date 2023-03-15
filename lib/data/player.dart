import 'package:equatable/equatable.dart';

class Player extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final int weight;
  final Gender gender;
  final SidePreference sidePreference;
  //TODO: wouldn't age group be a team-level attribute?
  final AgeGroup ageGroup;
  final bool drummerPreference;
  final bool steersPersonPreference;
  final bool strokePreference;

  const Player({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.weight,
    required this.gender,
    required this.sidePreference,
    required this.ageGroup,
    required this.drummerPreference,
    required this.steersPersonPreference,
    required this.strokePreference,
  });

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

class AgeGroup {
  final String label;

  const AgeGroup(this.label);

  @override
  String toString() {
    return label;
  }
}
