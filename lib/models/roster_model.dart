import 'package:dragonator/data/paddler.dart';
import 'package:dragonator/data/team.dart';
import 'package:dragonator/utils/easy_notifier.dart';

//TODO: add documentation
class RosterModel extends EasyNotifier {
  final Map<String, Paddler> _paddlerIDMap = {};

  final Map<String, Team> _teamIDMap = {};

  final Set<String> _ageGroups = {};

  Iterable<Paddler> get paddlers => _paddlerIDMap.values;

  Iterable<Team> get teams => _teamIDMap.values;

  Iterable<String> get ageGroups => _ageGroups;

  Paddler? getPaddler(String? id) => _paddlerIDMap[id];

  void assignPaddlerID(String id, Paddler paddler) =>
      notify(() => _paddlerIDMap[id] = paddler);

  void assignTeamID(String id, Team team) =>
      notify(() => _teamIDMap[id] = team);

  bool addAgeGroup(String ageGroup) => _ageGroups.add(ageGroup);

  void addToTeam(String teamID, String paddlerID) =>
      _teamIDMap[teamID]!.paddlerIDs.add(paddlerID);
}
