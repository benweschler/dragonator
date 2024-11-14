import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragonator/commands/paddler_write_commands.dart';
import 'package:dragonator/data/app_user.dart';
import 'package:dragonator/data/lineup.dart';
import 'package:dragonator/data/paddler.dart';
import 'package:dragonator/data/team.dart';
import 'package:dragonator/utils/notifier.dart';

//TODO: add documentation
class RosterModel extends Notifier {
  //TODO: if logging out replaces the roster model, no need for data members to ever be null.
  // The StreamSubscriptions corresponding to the realtime update subscriptions
  // from Firestore.
  StreamSubscription? _teamDocSubscription;
  StreamSubscription? _paddlersSubscription;

  Future<void> initialize(AppUser user) async {
    final firestore = FirebaseFirestore.instance;
    assert(_paddlerIDMap.isEmpty);
    assert(_teamIDMap.isEmpty);
    //TODO: add when lineups are fetched from db
    //assert(_lineupIDMap.isEmpty);

    // Load teams
    for (String teamID in user.teamIDs) {
      final teamSnapshot =
          await firestore.collection('teams').doc(teamID).get();
      final Map<String, dynamic> teamData = teamSnapshot.data()!;

      _teamIDMap[teamID] = Team(id: teamID, name: teamData['name']);
    }

    //TODO: store the last team that the user accessed
    // Load paddlers
    _currentTeamID = user.teamIDs.first;
    final currentTeamDoc = firestore.collection('teams').doc(_currentTeamID);
    final paddlersDoc = currentTeamDoc.collection('paddlers').doc('paddlers');
    final paddlersSnapshot = await paddlersDoc.get();
    final paddlers = paddlersSnapshot.data()!;

    for (final paddlerEntry in paddlers.entries) {
      _paddlerIDMap[paddlerEntry.key] = Paddler.fromFirestore(
        id: paddlerEntry.key,
        data: paddlerEntry.value,
      );
    }

    _teamDocSubscription = currentTeamDoc.snapshots().listen(_onTeamDocUpdate);
    _paddlersSubscription = paddlersDoc.snapshots().listen(_onPaddlerDocUpdate);

    notifyListeners();
  }

  //TODO: this should be modified to be used when switching teams. logging out should replace the roster model.
  void clear() {
    _paddlerIDMap.clear();
    _teamIDMap.clear();
    _currentTeamID = null;
    _lineupIDMap.clear();
    _teamDocSubscription?.cancel();
    _paddlersSubscription?.cancel();
  }

  void _onTeamDocUpdate(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final teamID = snapshot.id;
    final Map<String, dynamic> teamData = snapshot.data()!;

    // The the ID can not change over the lifetime of the team, so the only
    // field that could have changed is the name.
    _teamIDMap[teamID] = _teamIDMap[teamID]!.copyWith(name: teamData['name']);

    notifyListeners();
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

  String? get currentTeamID => _currentTeamID;

  //* LINEUP GETTERS *//

  Iterable<Lineup> get lineups => _lineupIDMap.values;

  Lineup? getLineup(String lineupID) => _lineupIDMap[lineupID];

  //* PADDLER SETTERS *//

  /// If [paddler] already exists, it is updated. If it does not exist, it is
  /// created.
  Future<void> setPaddler(Paddler paddler) =>
      setPaddlerCommand(paddler, _currentTeamID!);

  Future<void> deletePaddler(String paddlerID) =>
      deletePaddlerCommand(_currentTeamID!, paddlerID);

  //* TEAM SETTERS */

  //TODO: implement

  //* LINEUP SETTERS *//

  void setLineup(Lineup lineup) =>
      notify(() => _lineupIDMap[lineup.id] = lineup);

  void deleteLineup(String lineupID) =>
      notify(() => _lineupIDMap.remove(lineupID));
}
