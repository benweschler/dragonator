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

    // Update current team and load corresponding paddlers.
    //TODO: store the last team that the user accessed
    await _updateCurrentTeam(_teamIDMap.keys.elementAtOrNull(0));

    _teamsSubscription = teamsQuery.snapshots().listen(_onTeamsQueryUpdate);

    notify();
  }

  Future<void> _updateCurrentTeam(String? newTeamID) async {
    _currentTeamID = newTeamID;
    await _loadTeamPaddlers();
  }

  Future<void> _loadTeamPaddlers() async {
    _paddlersSubscription?.cancel();
    _paddlerIDMap.clear();

    if (_currentTeamID == null) return;

    final firestore = FirebaseFirestore.instance;
    final paddlersDoc =
        firestore.doc('teams/$_currentTeamID/paddlers/paddlers');
    final paddlersSnapshot = await paddlersDoc.get();
    final paddlers = paddlersSnapshot.data()!;

    for (final paddlerEntry in paddlers.entries) {
      _paddlerIDMap[paddlerEntry.key] = Paddler.fromFirestore(
        id: paddlerEntry.key,
        data: paddlerEntry.value,
      );
    }

    _paddlersSubscription = paddlersDoc.snapshots().listen(_onPaddlerDocUpdate);
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
    notify();
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

  void _onPaddlerDocUpdate(DocumentSnapshot snapshot) {
    final paddlerData = snapshot.data()! as Map<String, dynamic>;
    final paddlers = Set<Paddler>.from(paddlerData.entries.map(
      (entry) => Paddler.fromFirestore(id: entry.key, data: entry.value),
    ));

    final currentPaddlers = _paddlerIDMap.values.toSet();
    // Paddlers that were added or modified.
    final updatedPaddlers = paddlers.difference(currentPaddlers);

    final currentPaddlerIDs = _paddlerIDMap.keys.toSet();
    final paddlerIDs = paddlerData.keys.toSet();
    final removedPaddlerIDs = currentPaddlerIDs.difference(paddlerIDs);

    for (Paddler paddler in updatedPaddlers) {
      _paddlerIDMap[paddler.id] = paddler;
    }
    for (String id in removedPaddlerIDs) {
      _paddlerIDMap.remove(id);
    }

    notify();
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

  Team? get currentTeam => _teamIDMap[_currentTeamID];

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

  setCurrentTeam(String teamID) async {
    if (teamID == _currentTeamID || !_teamIDMap.containsKey(teamID)) return;
    await _updateCurrentTeam(teamID);
    notify();
  }

  Future<void> renameTeam(String teamID, String name) =>
      _renameTeamCommand(teamID, name);

  //* LINEUP SETTERS *//

  void setLineup(Lineup lineup) =>
      notify(() => _lineupIDMap[lineup.id] = lineup);

  void deleteLineup(String lineupID) =>
      notify(() => _lineupIDMap.remove(lineupID));
}
