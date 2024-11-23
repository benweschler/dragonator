import 'package:dragonator/data/paddler/paddler.dart';

abstract class PaddlerSort {
  static const sortingStrategyLabels = {
    'First Name': firstName,
    'Last Name': lastName,
    'Weight': weight,
  };

  static int firstName(Paddler a, Paddler b) =>
      a.firstName.caseBlindCompare(b.firstName);

  static int lastName(Paddler a, Paddler b) =>
      a.lastName.caseBlindCompare(b.lastName);

  static int weight(Paddler a, Paddler b) => a.weight.compareTo(b.weight);
}

extension _StringComparison on String {
  int caseBlindCompare(String other) =>
      toLowerCase().compareTo(other.toLowerCase());
}
