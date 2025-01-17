part of '../models/roster_model.dart';

Future<void> _setLineupCommand(Lineup lineup, String teamID) async {
  await getLineupsDoc(teamID)
      .set({lineup.id: lineup.toFirestore()}, SetOptions(merge: true));
}

Future<void> _deleteLineupCommand(String lineupID, String teamID) async {
  await getLineupsDoc(teamID).update({lineupID: FieldValue.delete()});
}
