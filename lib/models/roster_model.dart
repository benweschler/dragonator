import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragonator/commands/firestore_references.dart';
import 'package:dragonator/data/boat/boat.dart';
import 'package:dragonator/data/user/app_user.dart';
import 'package:dragonator/data/lineup/lineup.dart';
import 'package:dragonator/data/paddler/paddler.dart';
import 'package:dragonator/data/team/team.dart';
import 'package:dragonator/utils/notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';

part '../commands/team_commands.dart';

part '../commands/paddler_commands.dart';

part '../commands/lineup_commands.dart';

part '../commands/boat_commands.dart';

//TODO: add documentation
class RosterModel extends Notifier {
  // The StreamSubscriptions corresponding to the realtime update subscriptions
  // from Firestore.
  StreamSubscription? _teamsSubscription;
  StreamSubscription? _paddlersSubscription;
  StreamSubscription? _lineupsSubscription;
  StreamSubscription? _boatsSubscription;

  Future<void> initialize(AppUser user) async {
    assert(_paddlerIDMap.isEmpty);
    assert(_teamIDMap.isEmpty);
    assert(_lineupIDMap.isEmpty);

    // Load teams
    final teamsQuery = teamsCollection.where('owners', arrayContains: user.id);
    final QuerySnapshot snapshot = await teamsQuery.get();
    // Updates the teamIDMap
    _updateTeams(snapshot);

    await _updateCurrentTeamWithDetails(_teamIDMap.keys.elementAtOrNull(0));

    _teamsSubscription = teamsQuery.snapshots().listen(_onTeamsQueryUpdate);

    notify();
  }

  void clear() async {
    _currentTeamID = null;
    _teamIDMap.clear();
    _paddlerIDMap.clear();
    _lineupIDMap.clear();
    _boatIDMap.clear();
    await _teamsSubscription?.cancel();
    await _paddlersSubscription?.cancel();
    await _lineupsSubscription?.cancel();
    await _boatsSubscription?.cancel();
  }

  //* LOAD DATA *//

  /// Update the current current team and load the corresponding details:
  /// paddlers, lineups, and boats.
  ///
  /// Does nothing if current team is null (i.e. no teams exist).
  Future<void> _updateCurrentTeamWithDetails(String? newTeamID) async {
    _currentTeamID = newTeamID;
    await _loadTeamPaddlers();
    await _loadTeamLineups();
    await _loadTeamBoats();
  }

  Future<void> _loadTeamPaddlers() {
    return _loadTeamDetail(
      _paddlersSubscription,
      _getTeamPaddlersCommand,
      getPaddlersDoc,
      _paddlerIDMap,
      Paddler.fromFirestore,
      _onPaddlerDocUpdate,
    );
  }

  Future<void> _loadTeamLineups() {
    return _loadTeamDetail(
      _lineupsSubscription,
      _getTeamLineupsCommand,
      getLineupsDoc,
      _lineupIDMap,
      Lineup.fromFirestore,
      _onLineupDocUpdate,
    );
  }

  Future<void> _loadTeamBoats() {
    return _loadTeamDetail(
      _boatsSubscription,
      _getTeamBoatsCommand,
      getBoatsDoc,
      _boatIDMap,
      Boat.fromFirestore,
      _onBoatDocUpdate,
    );
  }

  Future<void> _loadTeamDetail<T extends dynamic>(
    StreamSubscription? updateSubscription,
    GetTeamDetailCommand getTeamDetailCommand,
    GetDetailDoc getDetailDoc,
    Map<String, T> idMap,
    DetailFromFirestore<T> fromFirestore,
    OnDetailUpdate onDetailUpdate,
  ) async {
    updateSubscription?.cancel();
    idMap.clear();

    // True if all teams are deleted.
    if (_currentTeamID == null) return;

    final Map<String, dynamic> details =
        await getTeamDetailCommand(_currentTeamID!);
    for (final detailEntry in details.entries) {
      idMap[detailEntry.key] = fromFirestore(
        id: detailEntry.key,
        data: detailEntry.value,
      );
    }

    updateSubscription =
        getDetailDoc(_currentTeamID!).snapshots().listen(onDetailUpdate);
  }

  //* UPDATE DATA *//

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

  void _onPaddlerDocUpdate(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return _updateTeamDetail(snapshot, _paddlerIDMap, Paddler.fromFirestore);
  }

  void _onLineupDocUpdate(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return _updateTeamDetail(snapshot, _lineupIDMap, Lineup.fromFirestore);
  }

  void _onBoatDocUpdate(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return _updateTeamDetail(snapshot, _boatIDMap, Boat.fromFirestore);
  }

  void _updateTeamDetail<T extends dynamic>(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    Map<String, T> idMap,
    DetailFromFirestore fromFirestore,
  ) async {
    final detailData = snapshot.data() ?? {};
    final details = Set<T>.from(detailData.entries.map(
      (entry) => fromFirestore(id: entry.key, data: entry.value),
    ));

    final currentDetails = idMap.values.toSet();
    // Details that were added or modified.
    final updatedDetails = details.difference(currentDetails);

    final currentDetailIDs = idMap.keys.toSet();
    final detailIDs = detailData.keys.toSet();
    final removedDetailIDs = currentDetailIDs.difference(detailIDs);

    for (T detail in updatedDetails) {
      idMap[detail.id] = detail;
    }
    for (String id in removedDetailIDs) {
      idMap.remove(id);
    }

    notify();
  }

  //* DATA *//

  String? _currentTeamID;
  final Map<String, Team> _teamIDMap = {};

  final Map<String, Paddler> _paddlerIDMap = {};

  //TODO: dummy Data
  final Map<String, Lineup> _lineupIDMap = {};

  final Map<String, Boat> _boatIDMap = {};

  //* TEAM GETTERS *//

  Iterable<Team> get teams => _teamIDMap.values;

  Team? getTeam(String? id) => _teamIDMap[id];

  Team? get currentTeam => _teamIDMap[_currentTeamID];

  //* PADDLER GETTERS *//

  Iterable<String> get paddlerIDs => _paddlerIDMap.keys;

  Iterable<Paddler> get paddlers => _paddlerIDMap.values;

  Paddler? getPaddler(String? id) => _paddlerIDMap[id];

  //* LINEUP GETTERS *//

  Iterable<Lineup> get lineups => _lineupIDMap.values;

  Lineup? getLineup(String lineupID) => _lineupIDMap[lineupID];

  //* BOAT GETTERS *//

  Iterable<Boat> get boats => _boatIDMap.values;

  Boat? getBoat(String boatID) => _boatIDMap[boatID];

  //* TEAM SETTERS *//

  Future<void> setCurrentTeam(String teamID) async {
    if (teamID == _currentTeamID || !_teamIDMap.containsKey(teamID)) return;
    await _updateCurrentTeamWithDetails(teamID);
    notify();
  }

  Future<void> renameTeam(String teamID, String name) =>
      _renameTeamCommand(teamID, name);

  Future<void> createTeam(String name) => _createTeamCommand(name);

  //* PADDLER SETTERS *//

  /// If [paddler] already exists, it is updated. If it does not exist, it is
  /// created.
  Future<void> setPaddler(Paddler paddler) =>
      _setPaddlerCommand(paddler, _currentTeamID!);

  Future<void> deletePaddler(String paddlerID) =>
      _deletePaddlerCommand(paddlerID, _currentTeamID!);

  //* LINEUP SETTERS *//

  Future<void> setLineup(Lineup lineup) =>
      _setLineupCommand(lineup, _currentTeamID!);

  void deleteLineup(String lineupID) =>
      _deleteLineupCommand(lineupID, _currentTeamID!);

  //* BOAT SETTERS *//

  Future<void> setBoat(Boat boat) => _setBoatCommand(boat, _currentTeamID!);

  void deleteBoat(String boatID) => _deleteBoatCommand(boatID, _currentTeamID!);
}

typedef GetTeamDetailCommand = Future<Map<String, dynamic>> Function(
  String currentTeamID,
);

typedef DetailFromFirestore<T> = T Function({
  required String id,
  required Map<String, dynamic> data,
});

typedef GetDetailDoc = DocumentReference<Map<String, dynamic>> Function(
  String teamID,
);

typedef OnDetailUpdate = void Function(
  DocumentSnapshot<Map<String, dynamic>> snapshot,
);
