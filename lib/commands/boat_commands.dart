part of '../models/roster_model.dart';

Future<Map<String, dynamic>> _getTeamBoatsCommand(
  String currentTeamID,
) async {
  final boatsSnapshot = await getBoatsDoc(currentTeamID).get();
  return boatsSnapshot.data() ?? {};
}

Future<void> _setBoatCommand(Boat boat, String teamID) async {
  await getBoatsDoc(teamID)
      .set({boat.id: boat.toFirestore()}, SetOptions(merge: true));
}

Future<void> _deleteBoatCommand(String boatID, String teamID) async {
  await getBoatsDoc(teamID).update({boatID: FieldValue.delete()});
}
