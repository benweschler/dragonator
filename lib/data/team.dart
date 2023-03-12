import 'package:equatable/equatable.dart';

class Team extends Equatable {
  final String name;

  /// A set of the player ID's of the players on this team.
  final Set<String> playerIDs;

  const Team({required this.name, this.playerIDs = const {}});

  @override
  List<Object?> get props => [name, playerIDs];
}