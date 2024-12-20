import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference<Map<String, dynamic>> teamsCollection =
    FirebaseFirestore.instance.collection('teams');

DocumentReference<Map<String, dynamic>> getTeamDoc(String teamID) {
  return FirebaseFirestore.instance.doc('teams/$teamID');
}

DocumentReference<Map<String, dynamic>> getUserDoc(String userID) {
  return FirebaseFirestore.instance.doc('users/$userID');
}

DocumentReference<Map<String, dynamic>> getSettingsDoc(String userID) {
  return FirebaseFirestore.instance.doc('users/$userID/details/settings');
}

DocumentReference<Map<String, dynamic>> getPaddlersDoc(String teamID) {
  return FirebaseFirestore.instance.doc('teams/$teamID/details/paddlers');
}

DocumentReference<Map<String, dynamic>> getLineupsDoc(String teamID) {
  return FirebaseFirestore.instance.doc('teams/$teamID/details/lineups');
}
