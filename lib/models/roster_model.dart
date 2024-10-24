import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragonator/commands/set_paddler_command.dart';
import 'package:dragonator/data/app_user.dart';
import 'package:dragonator/data/lineup.dart';
import 'package:dragonator/data/paddler.dart';
import 'package:dragonator/data/team.dart';
import 'package:dragonator/utils/notifier.dart';

//TODO: add documentation
class RosterModel extends Notifier {
  //TODO: no awaiting here means that data isn't loaded when roster screen shows
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
          paddlerData['teamID'] = teamID;

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

  /// If [paddler] already exists, it is updated. If it does not exist,
  /// it is created.
  void setPaddler(Paddler paddler) => SetPaddlerCommand.run(paddler);

  //TODO: dummy Data
  late final Map<String, Lineup> _lineupIDMap = {
    '1': Lineup(
      id: '1',
      name: 'Lineup One',
      paddlerIDs: paddlers.take(22).map((paddler) => paddler.id),
    ),
    '2': Lineup(
      id: '2',
      name: 'Lineup Two',
      paddlerIDs: paddlers.take(22).map((paddler) => paddler.id),
    ),
  };

  Iterable<Lineup> get lineups => _lineupIDMap.values;

  Lineup? getLineup(String lineupID) => _lineupIDMap[lineupID];

  void setLineup(Lineup lineup) =>
      notify(() => _lineupIDMap[lineup.id] = lineup);

  void deleteLineup(String lineupID) =>
      notify(() => _lineupIDMap.remove(lineupID));
}
