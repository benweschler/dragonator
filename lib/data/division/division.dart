import 'package:dragonator/data/paddler/paddler.dart';

typedef PaddlerFilter = bool Function(Iterable<Paddler>);

bool _all(Iterable<Paddler> paddlers, Gender gender) =>
    paddlers.every((paddler) => paddler.gender == gender);

bool _none(Iterable<Paddler> paddlers, Gender gender) =>
    paddlers.every((paddler) => paddler.gender != gender);

bool _ratio({
  required Set<Paddler> paddlers,
  required Gender gender,
  int? minRatio,
  int? maxRatio,
}) {
  final minBound = minRatio != null ? paddlers.length * minRatio : null;
  final maxBound = maxRatio != null ? paddlers.length * maxRatio : null;
  return _count(
    paddlers: paddlers,
    gender: gender,
    minBound: minBound,
    maxBound: maxBound,
  );
}

bool _count({
  required Set<Paddler> paddlers,
  required Gender gender,
  int? minBound,
  int? maxBound,
}) {
  final count = paddlers.where((paddler) => paddler.gender == gender).length;
  if (minBound != null && count < minBound) return false;
  if (maxBound != null && count > maxBound) return false;
  return true;
}

class Division {
  final String id;
  final String name;
  final Set<DivisionGenderRequirement> genderRequirements;
  final Set<AgeGroup> allowedAges;

  Division({
    required this.id,
    required this.name,
    required this.genderRequirements,
    required this.allowedAges,
  });
}

class DivisionGenderRequirement {
  final GenderRequirementType genderRequirementType;
  final Gender gender;
  final PaddlerFilter filter;
  final int? minBound;
  final int? maxBound;

  const DivisionGenderRequirement._({
    required this.gender,
    required this.filter,
    required this.genderRequirementType,
    required this.minBound,
    required this.maxBound,
  });

  DivisionGenderRequirement.all({required this.gender})
      : filter = ((paddlers) => _all(paddlers, gender)),
        genderRequirementType = GenderRequirementType.all,
        minBound = null,
        maxBound = null;
}

enum GenderRequirementType { all, numerical, ratio }
