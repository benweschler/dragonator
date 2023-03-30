import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragonator/data/app_user.dart';
import 'package:dragonator/data/paddler.dart';
import 'package:dragonator/data/team.dart';
import 'package:dragonator/utils/easy_notifier.dart';

//TODO: add documentation
class RosterModel extends EasyNotifier {
  Future<void> initialize(AppUser user) async {
    final firestore = FirebaseFirestore.instance;

    for (final teamID in user.teams) {
      firestore.collection('teams').doc(teamID).snapshots().listen((event) {
        final Map<String, dynamic> teamData = event.data()!;
        final Map<String, dynamic> paddlerJsons = teamData['paddlers'];

        _teamIDMap[teamID] = Team(
          id: teamID,
          name: teamData['name'],
          paddlerIDs: paddlerJsons.keys.toSet(),
        );

        for (String paddlerID in paddlerJsons.keys) {
          final paddlerData = paddlerJsons[paddlerID]!;
          paddlerData['id'] = paddlerID;

          _paddlerIDMap[paddlerID] = Paddler.fromJson(paddlerData);
        }
        notify(() {});
      });
    }
  }

  final Map<String, Paddler> _paddlerIDMap = {};

  final Map<String, Team> _teamIDMap = {};

  Iterable<Paddler> get paddlers => _paddlerIDMap.values;

  Iterable<Team> get teams => _teamIDMap.values;

  Paddler? getPaddler(String? id) => _paddlerIDMap[id];

  void assignPaddlerID(String id, Paddler paddler) =>
      notify(() => _paddlerIDMap[id] = paddler);

  void assignTeamID(String id, Team team) =>
      notify(() => _teamIDMap[id] = team);

  void addToTeam(String teamID, String paddlerID) =>
      _teamIDMap[teamID]!.copyWith(
        paddlerIDs: Set.from(_teamIDMap[teamID]!.paddlerIDs)..add(paddlerID),
      );
}
