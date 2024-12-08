part of '../models/roster_model.dart';

Future<void> _renameTeamCommand(String teamID, String name) async {
  await getTeamDoc(teamID).update({'name': name});
}

Future<void> _createTeamCommand(String name) async {
  await teamsCollection.add(Team.createFirestoreData(
    name: name,
    userID: FirebaseAuth.instance.currentUser!.uid,
  ));
}

Future<void> _deleteTeamCommand(String teamID) =>
    teamsCollection.doc(teamID).delete();
