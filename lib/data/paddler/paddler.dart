import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';

part 'paddler.freezed.dart';

part 'paddler.g.dart';

//TODO: make position preference a set of preference enums. None is just empty.

@Freezed(equal: false)
abstract class Paddler extends Equatable with _$Paddler {
  const Paddler._();

  const factory Paddler({
    required String id,
    required String firstName,
    required String lastName,
    required int weight,
    required Gender gender,
    required SidePreference? sidePreference,
    required AgeGroup ageGroup,
    required bool drummerPreference,
    required bool steersPersonPreference,
    required bool strokePreference,
    required bool cancerSurvivor,
  }) = _Paddler;

  factory Paddler.fromJson(Map<String, Object?> json) =>
      _$PaddlerFromJson(json);

  factory Paddler.fromFirestore({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return Paddler.fromJson(data..['id'] = id);
  }

  // Paddlers in Firestore have their ID as their key rather than a data member.
  Map<String, dynamic> toFirestore() => toJson()..remove('id');

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        weight,
        gender,
        sidePreference,
        ageGroup,
        drummerPreference,
        steersPersonPreference,
        strokePreference,
        cancerSurvivor,
      ];
}

enum SidePreference {
  left,
  strongLeft,
  right,
  strongRight,
  none;

  @override
  String toString() {
    switch (this) {
      case SidePreference.left:
        return 'Left';
      case SidePreference.right:
        return 'Right';
      case SidePreference.strongLeft:
        return 'Strong Left';
      case SidePreference.strongRight:
        return 'Strong Right';
      case SidePreference.none:
        return 'None';
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
        return 'M';
      case Gender.F:
        return 'F';
      case Gender.X:
        return 'X';
    }
  }
}

enum AgeGroup {
  youth,
  underForty,
  forties,
  fifties,
  sixties,
  aboveSeventies;

  @override
  String toString() {
    switch (this) {
      case AgeGroup.youth:
        return 'Youth';
      case AgeGroup.underForty:
        return 'Under 40';
      case AgeGroup.forties:
        return '40-49';
      case AgeGroup.fifties:
        return '50-59';
      case AgeGroup.sixties:
        return '60-69';
      case AgeGroup.aboveSeventies:
        return '70+';
    }
  }
}
