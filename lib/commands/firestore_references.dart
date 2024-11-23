part of '../models/roster_model.dart';

final CollectionReference<Map<String, dynamic>> _teamsCollection =
    FirebaseFirestore.instance.collection('teams');

DocumentReference<Map<String, dynamic>> _getPaddlersDoc(String teamID) {
  return FirebaseFirestore.instance
      .collection('teams')
      .doc(teamID)
      .collection('details')
      .doc('paddlers');
}

DocumentReference<Map<String, dynamic>> _getLineupsDoc(String teamID) {
  return FirebaseFirestore.instance
      .collection('teams')
      .doc(teamID)
      .collection('details')
      .doc('lineups');
}
