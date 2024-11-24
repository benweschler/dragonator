import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragonator/data/user/app_user.dart';
import 'package:dragonator/data/lineup/lineup.dart';
import 'package:dragonator/data/paddler/paddler.dart';
import 'package:dragonator/data/team/team.dart';
import 'package:dragonator/utils/notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';

part '../commands/team_commands.dart';

part '../commands/paddler_commands.dart';

part '../commands/lineup_commands.dart';

part '../commands/firestore_references.dart';

//TODO: add documentation
class RosterModel extends Notifier {
  // The StreamSubscriptions corresponding to the realtime update subscriptions
  // from Firestore.
  StreamSubscription? _teamsSubscription;
  StreamSubscription? _paddlersSubscription;
  StreamSubscription? _lineupsSubscription;

  Future<void> initialize(AppUser user) async {
    assert(_paddlerIDMap.isEmpty);
    assert(_teamIDMap.isEmpty);
    assert(_lineupIDMap.isEmpty);

    // Load teams
    final teamsQuery = _teamsCollection.where('owners', arrayContains: user.id);
    final QuerySnapshot snapshot = await teamsQuery.get();
    _updateTeams(snapshot);

    // Update current team and load corresponding paddlers. Does nothing if
    // current team is null (i.e. no teams exist).
    //TODO: store the last team that the user accessed
    await _updateCurrentTeam(_teamIDMap.keys.elementAtOrNull(0));

    _teamsSubscription = teamsQuery.snapshots().listen(_onTeamsQueryUpdate);

    notify();
  }

  Future<void> _updateCurrentTeam(String? newTeamID) async {
    _currentTeamID = newTeamID;
    await _loadTeamPaddlers();
    await _loadTeamLineups();
  }

  Future<void> _loadTeamPaddlers() async {
    _paddlersSubscription?.cancel();
    _paddlerIDMap.clear();

    // Could be the case if all teams are deleted.
    if (_currentTeamID == null) return;

    final Map<String, dynamic> paddlers =
        await _getTeamPaddlersCommand(_currentTeamID!);
    for (final paddlerEntry in paddlers.entries) {
      _paddlerIDMap[paddlerEntry.key] = Paddler.fromFirestore(
        id: paddlerEntry.key,
        data: paddlerEntry.value,
      );
    }

    _paddlersSubscription = _getPaddlersDoc(_currentTeamID!)
        .snapshots()
        .listen(_onPaddlerDocUpdate);
  }

  Future<void> _loadTeamLineups() async {
    _lineupsSubscription?.cancel();
    _lineupIDMap.clear();

    // Could be the case if all teams are deleted.
    if (_currentTeamID == null) return;

    final Map<String, dynamic> lineups =
        await _getTeamLineupsCommand(_currentTeamID!);
    for (final lineupEntry in lineups.entries) {
      _lineupIDMap[lineupEntry.key] = Lineup.fromFirestore(
        id: lineupEntry.key,
        data: lineupEntry.value,
      );
    }

    _lineupsSubscription =
        _getLineupsDoc(_currentTeamID!).snapshots().listen(_onLineupDocUpdate);
  }

  //TODO: this should be modified to be used when switching teams. logging out should replace the roster model.
  void clear() {
    _teamIDMap.clear();
    _currentTeamID = null;
    _teamsSubscription?.cancel();
    _paddlerIDMap.clear();
    _paddlersSubscription?.cancel();
    _lineupIDMap.clear();
    //TODO: add once lineups are pulled from db cancel subscription
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

  void _onPaddlerDocUpdate(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return _updateTeamDetail(snapshot, _paddlerIDMap, Paddler.fromFirestore);
  }

  void _onLineupDocUpdate(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return _updateTeamDetail(snapshot, _lineupIDMap, Lineup.fromFirestore);
  }

  void _updateTeamDetail<T extends dynamic>(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    Map<String, T> idMap,
    T Function({
      required String id,
      required Map<String, dynamic> data,
    }) fromFirestore,
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

  //* TEAM SETTERS *//

  Future<void> setCurrentTeam(String teamID) async {
    if (teamID == _currentTeamID || !_teamIDMap.containsKey(teamID)) return;
    await _updateCurrentTeam(teamID);
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
}
