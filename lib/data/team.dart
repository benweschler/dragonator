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
    required Set<String> paddlerIDs,
  }) = _Team;

  factory Team.fromJson(Map<String, Object?> json) => _$TeamFromJson(json);

  @override
  List<Object?> get props => [id];
}
