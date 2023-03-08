import 'package:equatable/equatable.dart';

class Player extends Equatable {
  final String id;
  final String name;
  final int weight;
  final Gender gender;
  final SidePreference sidePreference;
  final AgeGroup ageGroup;
  final bool drummerPreference;
  final bool steersPersonPreference;
  final bool strokePreference;

  const Player({
    required this.id,
    required this.name,
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

enum SidePreference { left, right }

enum Gender { M, F, X }

enum AgeGroup { youth, adult }
