import 'dart:math';

import 'package:dragonator/data/player.dart';
import 'package:dragonator/data/team.dart';
import 'package:uuid/uuid.dart';

const Uuid uuid = Uuid();
final Random random = Random();
const List<String> names = [
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

final teamOne = Team(
  name: "Team One",
  roster: {
    for(int i = 0; i < 22; i++)
      randomPlayer()
  },
);

final teamTwo = Team(
  name: "Team Two",
  roster: {
    for(int i = 0; i < 22; i++)
      randomPlayer()
  },
);

Player randomPlayer() {
  return Player(
    id: uuid.v4(),
    name: names[random.nextInt(names.length-1)],
    weight: random.nextInt(75) + 110,
    gender: Gender.values[random.nextInt(2)],
    sidePreference: random.nextBool() ? SidePreference.left : SidePreference.right,
    ageGroup: random.nextBool() ? AgeGroup.adult : AgeGroup.youth,
    drummerPreference: random.nextBool(),
    steersPersonPreference: random.nextBool(),
    strokePreference: random.nextBool(),
  );
}
