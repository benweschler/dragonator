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

class RosterModel extends Notifier {
  // The StreamSubscriptions corresponding to the realtime update subscriptions
  // from Firestore.
  StreamSubscription? _teamsSubscription;
  StreamSubscription? _paddlersSubscription;
  StreamSubscription? _lineupsSubscription;

  final _teamDeletedListeners = _TeamDeletedListenerManager();
  late void Function(String) _showCurrentTeamDeletedDialog;

  Future<void> initialize({
    required AppUser user,
    //TODO: should be renamed because also pops to root
    required void Function(String) showCurrentTeamDeletedDialog,
  }) async {
    assert(_paddlerIDMap.isEmpty);
    assert(_teamIDMap.isEmpty);
    assert(_lineupIDMap.isEmpty);

    _showCurrentTeamDeletedDialog = showCurrentTeamDeletedDialog;

    // Load teams
    final teamsQuery = teamsCollection.where('owners', arrayContains: user.id);
    final QuerySnapshot snapshot = await teamsQuery.get();
    // Updates the teamIDMap
    _updateTeams(snapshot);

    await _updateCurrentTeamWithDetails(_teamIDMap.keys.elementAtOrNull(0));

    _teamsSubscription = teamsQuery.snapshots().listen(_onTeamsQueryUpdate);

    notifyListeners();
  }

  void clear() async {
    _currentTeamID = null;
    _teamIDMap.clear();
    _paddlerIDMap.clear();
    _lineupIDMap.clear();
    _teamDeletedListeners.clear();
    await _teamsSubscription?.cancel();
    await _paddlersSubscription?.cancel();
    await _lineupsSubscription?.cancel();
  }

  //* DATA *//

  String? _currentTeamID;
  final Map<String, Team> _teamIDMap = {};

  final Map<String, Paddler> _paddlerIDMap = {};

  final Map<String, Lineup> _lineupIDMap = {};

  //* LISTENERS *//

  void addTeamDeletedListener(String teamID, TeamDeletedListener listener) {
    _teamDeletedListeners.addTeamDeletedListener(teamID, listener);
  }

  void removeTeamDeletedListener(String teamID, TeamDeletedListener listener) {
    _teamDeletedListeners.removeTeamDeletedListener(teamID, listener);
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
    for (var detailEntry in details.entries) {
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
    final currentTeamName = currentTeam?.name;
    _updateTeams(snapshot);
    if (_currentTeamID != null && !_teamIDMap.keys.contains(_currentTeamID)) {
      _onCurrentTeamDeleted(currentTeamName!, false);
    }

    notifyListeners();
  }

  void _updateTeams(QuerySnapshot snapshot) {
    for (var docChange in snapshot.docChanges) {
      final id = docChange.doc.id;

      if (docChange.type == DocumentChangeType.removed) {
        _teamDeletedListeners.notifyTeamListeners(
          id: id,
          teamName: _teamIDMap[id]!.name,
          isCurrentTeam: id == _currentTeamID,
        );
        _teamIDMap.remove(id);
      } else {
        final teamData = docChange.doc.data() as Map<String, dynamic>;
        _teamIDMap[id] = Team.fromFirestore(id: id, data: teamData);
      }
    }
  }

  // userInitiated tracks whether the user initiated the team deletion or
  // whether it was initiated from another source (like a collaborator).
  void _onCurrentTeamDeleted(String deletedTeamName, bool userInitiated) {
    _updateCurrentTeamWithDetails(
      _teamIDMap.isEmpty ? null : _teamIDMap.keys.first,
    );
    // Show a popup if a collaborator deletes the current team.
    if (!userInitiated) {
      _showCurrentTeamDeletedDialog(deletedTeamName);
    }
  }

  void _onPaddlerDocUpdate(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return _updateTeamDetail(snapshot, _paddlerIDMap, Paddler.fromFirestore);
  }

  void _onLineupDocUpdate(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return _updateTeamDetail(snapshot, _lineupIDMap, Lineup.fromFirestore);
  }

  // Callback fired when a team detail is updated in Firestore.
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

    notifyListeners();
  }

  //* TEAM GETTERS *//

  Iterable<Team> get teams => _teamIDMap.values;

  Team? getTeam(String? id) => _teamIDMap[id];

  Team? get currentTeam => _teamIDMap[_currentTeamID];

  static Future<bool> checkTeamExists(String teamID) =>
      _checkTeamExistsCommand(teamID);

  //* PADDLER GETTERS *//

  Iterable<String> get paddlerIDs => _paddlerIDMap.keys;

  Iterable<Paddler> get paddlers => _paddlerIDMap.values;

  Paddler? getPaddler(String? id) => _paddlerIDMap[id];

  //* LINEUP GETTERS *//

  Iterable<Lineup> get lineups => _lineupIDMap.values;

  Lineup? getLineup(String lineupID) => _lineupIDMap[lineupID];

  Boat? getLineupBoat(String lineupID) {
    return currentTeam?.boats[_lineupIDMap[lineupID]?.boatID];
  }

  //* TEAM SETTERS *//

  Future<void> setCurrentTeam(String teamID) async {
    if (teamID == _currentTeamID || !_teamIDMap.containsKey(teamID)) return;
    await _updateCurrentTeamWithDetails(teamID);
  }

  Future<void> renameTeam(String teamID, String name) =>
      _renameTeamCommand(teamID, name);

  Future<void> createTeam(String name) => _createTeamCommand(name);

  Future<void> deleteTeam(String teamID) async {
    if (!_teamIDMap.containsKey(teamID)) return;

    _teamDeletedListeners.notifyTeamListeners(
      id: teamID,
      teamName: _teamIDMap[teamID]!.name,
      isCurrentTeam: teamID == _currentTeamID,
    );

    // Update the current team prior to deleting it to distinguish between the
    // user deleting the current team and a collaborator deleting a current
    // team in _onTeamQueryUpdate.
    if (teamID == _currentTeamID) {
      _onCurrentTeamDeleted(_teamIDMap[teamID]!.name, true);
    }

    return _deleteTeamCommand(teamID);
  }

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

  Future<void> setLineupBoat(String lineupID, String boatID) async {
    final lineup = getLineup(lineupID);
    final boat = currentTeam!.boats[boatID];
    if (boat == null || lineup == null) return;

    final paddlerIDs = lineup.paddlerIDs.toList();
    final newLineup = lineup.copyWith(
      boatID: boatID,
      paddlerIDs: List.generate(
        boat.capacity,
        (index) => index < paddlerIDs.length ? paddlerIDs[index] : null,
      ),
    );

    _setLineupCommand(newLineup, _currentTeamID!);
  }

  void deleteLineup(String lineupID) =>
      _deleteLineupCommand(lineupID, _currentTeamID!);

  //* BOAT SETTERS *//

  Future<void> setBoat(Boat boat, String teamID) async {
    await _setBoatCommand(boat, teamID);
    //TODO: should not be here. after removed, return above and remove async
    final lineupsWithBoat =
        _lineupIDMap.values.where((lineup) => lineup.boatID == boat.id);
    for (Lineup lineup in lineupsWithBoat) {
      var paddlerList = List<String?>.generate(
        boat.capacity,
        (index) => index < lineup.paddlerIDs.length
            ? lineup.paddlerIDs.toList()[index]
            : null,
      );
      await setLineup(lineup.copyWith(paddlerIDs: paddlerList));
    }
  }

  Future<void> deleteBoat(String boatID, String teamID) =>
      _deleteBoatCommand(boatID, teamID);
}

class _TeamDeletedListenerManager {
  final Map<String, List<TeamDeletedListener?>> _teamDeletedListeners = {};
  final Map<String, int> _notificationCallStackDepths = {};

  void addTeamDeletedListener(String id, TeamDeletedListener listener) {
    if (_teamDeletedListeners[id] == null) {
      _teamDeletedListeners[id] = [listener];
      _notificationCallStackDepths[id] = 0;
    } else {
      _teamDeletedListeners[id]!.add(listener);
    }
  }

  void removeTeamDeletedListener(String id, TeamDeletedListener listener) {
    final listeners = _teamDeletedListeners[id];
    if (listeners == null) return;

    // Prevents concurrent modification of listeners while listeners are being
    // called.
    if (_notificationCallStackDepths[id] == 0) {
      listeners.remove(listener);
      _cleanTeamListeners(id);
    } else {
      for (int i = 0; i < listeners.length; i++) {
        if (listeners[i] == listener) {
          listeners[i] = null;
        }
      }
    }
  }

  void notifyTeamListeners({
    required String id,
    required String teamName,
    required bool isCurrentTeam,
  }) {
    if (_teamDeletedListeners[id] == null) return;

    _notificationCallStackDepths[id] = _notificationCallStackDepths[id]! + 1;

    for (var listener in _teamDeletedListeners[id]!) {
      listener?.call(teamName: teamName, isCurrentTeam: isCurrentTeam);
    }

    _notificationCallStackDepths[id] = _notificationCallStackDepths[id]! - 1;

    if (_notificationCallStackDepths[id] == 0) {
      _cleanTeamListeners(id);
    }
  }

  void clear() => _teamDeletedListeners.clear();

  void _cleanTeamListeners(String id) {
    _teamDeletedListeners[id]?.removeWhere((listener) => listener == null);
    if (_teamDeletedListeners[id]?.isEmpty == true) {
      _teamDeletedListeners.remove(id);
    }
  }
}

typedef TeamDeletedListener = void Function(
    {required String teamName, required bool isCurrentTeam});

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
