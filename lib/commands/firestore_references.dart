import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference<Map<String, dynamic>> teamsCollection =
    FirebaseFirestore.instance.collection('teams');

DocumentReference<Map<String, dynamic>> getUserDoc(String userID) {
  return FirebaseFirestore.instance.doc('users/$userID');
}

DocumentReference<Map<String, dynamic>> getPaddlersDoc(String teamID) {
  return FirebaseFirestore.instance.doc('teams/$teamID/details/paddlers');
}

DocumentReference<Map<String, dynamic>> getLineupsDoc(String teamID) {
  return FirebaseFirestore.instance.doc('teams/$teamID/details/lineups');
}

DocumentReference<Map<String, dynamic>> getBoatsDoc(String teamID) {
  return FirebaseFirestore.instance.doc('teams/$teamID/details/boats');
}
