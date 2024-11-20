part of '../models/roster_model.dart';

Future<void> _renameTeamCommand(String teamID, String name) async {
  await FirebaseFirestore.instance
      .collection('teams')
      .doc(teamID)
      .update({'name': name});
}

Future<void> _createTeamCommand(String name) async {
  final docReference = await FirebaseFirestore.instance
      .collection('teams')
      .add(Team.createFirestoreData(
        name: name,
        userID: FirebaseAuth.instance.currentUser!.uid,
      ));
  await docReference
      .collection('paddlers')
      .doc('paddlers')
      .set({'paddlers': []});
}
