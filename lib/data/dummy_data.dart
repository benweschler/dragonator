import 'dart:math';

import 'package:dragonator/data/player.dart';
import 'package:dragonator/data/team.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:uuid/uuid.dart';

const Uuid _uuid = Uuid();
final Random _random = Random();

void assignDummyData(RosterModel rosterModel) {
  for(String ageGroup in _ageGroups) {
    rosterModel.addAgeGroup(ageGroup);
  }

  final dummyRoster = [for (int i = 0; i < 22 * 2; i++) _randomPlayer()];

  for (final player in dummyRoster) {
    rosterModel.assignPlayerID(player.id, player);
  }

  final teamOne = Team(
    id: _uuid.v4(),
    name: 'Team One',
    playerIDs: dummyRoster
        .map((player) => player.id)
        .take(dummyRoster.length ~/ 2)
        .toSet(),
  );

  final teamTwo = Team(
    id: _uuid.v4(),
    name: 'Team Two',
    playerIDs: dummyRoster
        .map((player) => player.id)
        .toList()
        .sublist(dummyRoster.length ~/ 2)
        .toSet(),
  );

  rosterModel.assignTeamID(teamOne.id, teamOne);
  rosterModel.assignTeamID(teamTwo.id, teamTwo);
}

Player _randomPlayer() {
  return Player(
    id: _uuid.v4(),
    firstName: _firstNames[_random.nextInt(_firstNames.length - 1)],
    lastName: _lastNames[_random.nextInt(_lastNames.length - 1)],
    weight: _random.nextInt(75) + 110,
    gender: Gender.values[_random.nextInt(3)],
    sidePreference:
        _random.nextBool() ? SidePreference.left : SidePreference.right,
    ageGroup: _ageGroups[_random.nextInt(_ageGroups.length - 1)],
    drummerPreference: _random.nextBool(),
    steersPersonPreference: _random.nextBool(),
    strokePreference: _random.nextBool(),
  );
}

const List<String> _firstNames = [
  'Ben',
  'Pang',
  'Adam',
  'Tyriq',
  'Aaron',
  'Adee',
  'Itai',
  'Fabio',
  'Luis',
  'Emma',
  'Valencia',
  'Talia',
];

const List<String> _lastNames = [
  'Weschler',
  'Lawrence',
  'Storm',
  'Williams',
  'Kaplan',
  'Gilad',
  'Buzi',
  'Ferrera',
  'Mendez',
  'Stone',
  'White',
  'Gottfried',
];

const List<String> _ageGroups = ['Adult', 'Youth'];
