part of '../models/roster_model.dart';

Future<Map<String, dynamic>> _getTeamLineupsCommand(
  String currentTeamID,
) async {
  final lineupsSnapshot = await _getLineupsDoc(currentTeamID).get();
  return lineupsSnapshot.data() ?? {};
}

Future<void> _setLineupCommand(Lineup lineup, String teamID) async {
  await _getLineupsDoc(teamID)
      .set({lineup.id: lineup.toFirestore()}, SetOptions(merge: true));
}

Future<void> _deleteLineupCommand(String lineupID, String teamID) async {
  await _getLineupsDoc(teamID).update({lineupID: FieldValue.delete()});
}
