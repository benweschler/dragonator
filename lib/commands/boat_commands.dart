part of '../models/roster_model.dart';

Future<void> _setBoatCommand(Boat boat, String teamID) async {
  await getTeamDoc(teamID).update({'boats.${boat.id}': boat.toFirestore()});
}

Future<void> _deleteBoatCommand(String boatID, String teamID) async {
  await getTeamDoc(teamID).update({'boats.$boatID': FieldValue.delete()});
}

/// Returns the names of the lineups where a boat is in use.
Future<List<String>> _getLineupsUsingBoatCommand(
  String teamID,
  String boatID,
) async {
  final inUseLineupNames = <String>[];

  final snapshot = await getLineupsDoc(teamID).get();
  final lineups = snapshot.data();

  if (lineups == null) return inUseLineupNames;

  for (Map<String, dynamic> lineupData in lineups.values) {
    if (lineupData['boatID'] == boatID) {
      inUseLineupNames.add(lineupData['name']);
    }
  }

  return inUseLineupNames;
}
