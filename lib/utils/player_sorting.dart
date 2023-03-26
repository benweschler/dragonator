import 'package:dragonator/data/player.dart';

abstract class PlayerSort {
  static const sortingStrategyLabels = {
    'First Name' : firstName,
    'Last Name' : lastName,
    'Weight' : weight,
  };

  static int firstName(Player a, Player b) =>
      a.firstName.compareTo(b.firstName);

  static int lastName(Player a, Player b) =>
      a.lastName.compareTo(b.lastName);

  static int weight(Player a, Player b) => a.weight.compareTo(b.weight);
}
