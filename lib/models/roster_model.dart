import 'package:dragonator/data/player.dart';
import 'package:dragonator/data/team.dart';
import 'package:dragonator/utils/easy_notifier.dart';

//TODO: add documentation
class RosterModel extends EasyNotifier {
  final Map<String, Player> _playerIDMap = {};

  final Map<String, Team> _teamIDMap = {};

  final Set<String> _ageGroups = {};

  Iterable<Player> get players => _playerIDMap.values;

  Iterable<Team> get teams => _teamIDMap.values;

  Iterable<String> get ageGroups => _ageGroups;

  Player? getPlayer(String? id) => _playerIDMap[id];

  void assignPlayerID(String id, Player player) =>
      notify(() => _playerIDMap[id] = player);

  void assignTeamID(String id, Team team) =>
      notify(() => _teamIDMap[id] = team);

  bool addAgeGroup(String ageGroup) => _ageGroups.add(ageGroup);

  void addToTeam(String teamID, String playerID) =>
      _teamIDMap[teamID]!.playerIDs.add(playerID);
}
