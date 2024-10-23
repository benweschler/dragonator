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

  @override
  List<Object?> get props => [id];
}
