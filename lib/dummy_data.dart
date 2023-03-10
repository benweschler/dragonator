import 'dart:math';

import 'package:dragonator/data/player.dart';
import 'package:dragonator/data/team.dart';
import 'package:uuid/uuid.dart';

const Uuid _uuid = Uuid();
final Random _random = Random();
const List<String> _firstNames = [
  "Ben",
  "Pang",
  "Adam",
  "Tyriq",
  "Aaron",
  "Adee",
  "Itai",
  "Fabio",
  "Luis",
  "Emma",
  "Valencia",
  "Talia",
];

const List<String> _lastNames = [
  "Weschler",
  "Lawrence",
  "Storm",
  "Williams",
  "Kaplan",
  "Gilad",
  "Buzi",
  "Ferrera",
  "Mendez",
  "Stone",
  "White",
  "Gottfried",
];

final roster = [for (int i = 0; i < 22 * 2; i++) _randomPlayer()];
final Map<String, Player> playerIDMap =
    Map.fromIterable(roster, key: (player) => player.id);

final teamOne = Team(
  name: "Team One",
  playerIDs: roster.sublist(0, 22).map((player) => player.id).toSet(),
);

final teamTwo = Team(
  name: "Team Two",
  playerIDs: roster.sublist(22).map((player) => player.id).toSet(),
);

Player _randomPlayer() {
  return Player(
    id: _uuid.v4(),
    firstName: _firstNames[_random.nextInt(_firstNames.length - 1)],
    lastName: _lastNames[_random.nextInt(_lastNames.length - 1)],
    weight: _random.nextInt(75) + 110,
    gender: Gender.values[_random.nextInt(3)],
    sidePreference:
        _random.nextBool() ? SidePreference.left : SidePreference.right,
    ageGroup: _random.nextBool() ? AgeGroup.adult : AgeGroup.youth,
    drummerPreference: _random.nextBool(),
    steersPersonPreference: _random.nextBool(),
    strokePreference: _random.nextBool(),
  );
}
