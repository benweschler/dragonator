import 'package:dragonator/data/player.dart';
import 'package:equatable/equatable.dart';

class Team extends Equatable {
  final String name;
  final Set<Player> roster;

  const Team({required this.name, this.roster = const {}});

  @override
  List<Object?> get props => [];
}