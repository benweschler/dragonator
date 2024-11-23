part of '../models/roster_model.dart';

/*
TODO
Future<Map<String, dynamic>> _getTeamPaddlersCommand(
  String currentTeamID,
) async {
  final firestore = FirebaseFirestore.instance;
  final paddlersDoc = firestore.doc('teams/$currentTeamID/details/paddlers');
  final paddlersSnapshot = await paddlersDoc.get();
  return paddlersSnapshot.data() ?? {};
}

 */

Future<void> _setPaddlerCommand(Paddler paddler, String teamID) async {
  await FirebaseFirestore.instance
      .collection('teams')
      .doc(teamID)
      .collection('details')
      .doc('paddlers')
      .set({paddler.id: paddler.toFirestore()}, SetOptions(merge: true));
}

Future<void> _deletePaddlerCommand(String teamID, String paddlerID) async {
  await FirebaseFirestore.instance
      .collection('teams')
      .doc(teamID)
      .collection('details')
      .doc('paddlers')
      .update({paddlerID: FieldValue.delete()});
}
