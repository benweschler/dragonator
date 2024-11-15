import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragonator/data/app_user.dart';
import 'package:dragonator/data/lineup.dart';
import 'package:dragonator/data/paddler.dart';
import 'package:dragonator/data/team.dart';
import 'package:dragonator/utils/notifier.dart';

part '../commands/paddler_commands.dart';

part '../commands/team_commands.dart';

//TODO: add documentation
class RosterModel extends Notifier {
  //TODO: if logging out replaces the roster model, no need for data members to ever be null.
  // The StreamSubscriptions corresponding to the realtime update subscriptions
  // from Firestore.
  StreamSubscription? _teamsSubscription;
  StreamSubscription? _paddlersSubscription;

  Future<void> initialize(AppUser user) async {
    final firestore = FirebaseFirestore.instance;
    assert(_paddlerIDMap.isEmpty);
    assert(_teamIDMap.isEmpty);
    //TODO: add when lineups are fetched from db
    //assert(_lineupIDMap.isEmpty);

    // Load teams
    final teamsQuery =
        firestore.collection('teams').where('owners', arrayContains: user.id);
    final QuerySnapshot snapshot = await teamsQuery.get();
    _updateTeams(snapshot);
    //TODO: store the last team that the user accessed
    _currentTeamID = _teamIDMap.keys.first;

    // Load paddlers
    final paddlersDoc = firestore.doc('teams/$_currentTeamID/paddlers/paddlers');
    final paddlersSnapshot = await paddlersDoc.get();
    final paddlers = paddlersSnapshot.data()!;

    for (final paddlerEntry in paddlers.entries) {
      _paddlerIDMap[paddlerEntry.key] = Paddler.fromFirestore(
        id: paddlerEntry.key,
        data: paddlerEntry.value,
      );
    }

    _teamsSubscription = teamsQuery.snapshots().listen(_onTeamsQueryUpdate);
    _paddlersSubscription = paddlersDoc.snapshots().listen(_onPaddlerDocUpdate);

    notifyListeners();
  }

  //TODO: this should be modified to be used when switching teams. logging out should replace the roster model.
  void clear() {
    _paddlerIDMap.clear();
    _teamIDMap.clear();
    _currentTeamID = null;
    //TODO: add once lineups are pulled from db _lineupIDMap.clear();
    _teamsSubscription?.cancel();
    _paddlersSubscription?.cancel();
  }

  void _onTeamsQueryUpdate(QuerySnapshot snapshot) {
    final List<DocumentSnapshot> teamDocs = snapshot.docs;
    if (!teamDocs.map((doc) => doc.id).contains(_currentTeamID)) {
      //TODO: implement popup/refresh if current team is deleted
      throw UnimplementedError('Current team has been deleted');
    }

    _updateTeams(snapshot);
    notifyListeners();
  }

  void _updateTeams(QuerySnapshot snapshot) {
    for (final docChange in snapshot.docChanges) {
      final id = docChange.doc.id;

      if (docChange.type == DocumentChangeType.removed) {
        _teamIDMap.remove(id);
      } else {
        final teamData = docChange.doc.data() as Map<String, dynamic>;
        _teamIDMap[id] = Team.fromFirestore(id: id, data: teamData);
      }
    }
  }

  void _onPaddlerDocUpdate(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) async {
    final Map<String, dynamic> paddlers = snapshot.data()!;
    final Set<String> paddlerIDs = paddlers.keys.toSet();

    final currentPaddlerIDs = _paddlerIDMap.keys.toSet();
    final addedPaddlers = paddlerIDs.difference(currentPaddlerIDs);
    final removedPaddlers = currentPaddlerIDs.toSet().difference(paddlerIDs);

    for (String id in addedPaddlers) {
      _paddlerIDMap[id] = Paddler.fromFirestore(id: id, data: paddlers[id]);
    }

    for (String id in removedPaddlers) {
      _paddlerIDMap.remove(id);
    }

    notifyListeners();
  }

  //* DATA *//

  final Map<String, Paddler> _paddlerIDMap = {};

  final Map<String, Team> _teamIDMap = {};

  String? _currentTeamID;

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

  //* PADDLER GETTERS *//

  Iterable<String> get paddlerIDs => _paddlerIDMap.keys;

  Iterable<Paddler> get paddlers => _paddlerIDMap.values;

  Paddler? getPaddler(String? id) => _paddlerIDMap[id];

  //* TEAM GETTERS *//

  Iterable<Team> get teams => _teamIDMap.values;

  Team? getTeam(String? id) => _teamIDMap[id];

  String? get currentTeamID => _currentTeamID;

  //* LINEUP GETTERS *//

  Iterable<Lineup> get lineups => _lineupIDMap.values;

  Lineup? getLineup(String lineupID) => _lineupIDMap[lineupID];

  //* PADDLER SETTERS *//

  /// If [paddler] already exists, it is updated. If it does not exist, it is
  /// created.
  Future<void> setPaddler(Paddler paddler) =>
      _setPaddlerCommand(paddler, _currentTeamID!);

  Future<void> deletePaddler(String paddlerID) =>
      _deletePaddlerCommand(_currentTeamID!, paddlerID);

  //* TEAM SETTERS */

  Future<void> renameTeam(String teamID, String name) =>
      _renameTeamCommand(teamID, name);

  //* LINEUP SETTERS *//

  void setLineup(Lineup lineup) =>
      notify(() => _lineupIDMap[lineup.id] = lineup);

  void deleteLineup(String lineupID) =>
      notify(() => _lineupIDMap.remove(lineupID));
}
