part of '../models/roster_model.dart';

Future<void> _setBoatCommand(Boat boat, String teamID) async {
  await getTeamDoc(teamID).update({'boats.${boat.id}': boat.toFirestore()});
}

Future<void> _deleteBoatCommand(String boatID, String teamID) async {
  await getTeamDoc(teamID).update({'boats.$boatID': FieldValue.delete()});
}
