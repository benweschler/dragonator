import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lineup.freezed.dart';

part 'lineup.g.dart';

// Define equality only based on id using Equatable. This means that two Lineups
// are equal if their ids are equal.
@Freezed(equal: false)
class Lineup extends Equatable with _$Lineup {
  const Lineup._();

  const factory Lineup({
    required String id,
    required String name,
    required Iterable<String?> paddlerIDs,
  }) = _Lineup;

  factory Lineup.fromJson(Map<String, Object?> json) => _$LineupFromJson(json);

  factory Lineup.fromFirestore({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return Lineup.fromJson(data..['id'] = id);
  }

  // Lineups in Firestore have their ID as their key rather than a data member.
  Map<String, dynamic> toFirestore() => toJson()..remove('id');

  @override
  List<Object?> get props => [id, name, paddlerIDs];
}
