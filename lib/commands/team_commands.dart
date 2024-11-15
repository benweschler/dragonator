part of '../models/roster_model.dart';

Future<void> _renameTeamCommand(String teamID, String name) async {
  await FirebaseFirestore.instance
      .collection('teams')
      .doc(teamID)
      .update({'name': name});
}

/*
TODO: User teams data has to be restructured on Firestore. Teams should be a sub-document of user. AppUser should read top-level user, and RosterModel should read teams and open a realtime listener.
Future<void> _createTeamCommand(String name) async {
  final teamData = {'name': name};
  final docReference =
      await FirebaseFirestore.instance.collection('teams').add(teamData);
  return Team.fromFirestore(id: docReference.id, data: teamData);
}
 */
