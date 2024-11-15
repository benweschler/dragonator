part of '../models/roster_model.dart';

Future<void> _setPaddlerCommand(Paddler paddler, String teamID) async {
  await FirebaseFirestore.instance
      .collection('teams')
      .doc(teamID)
      .collection('paddlers')
      .doc('paddlers')
      .update({paddler.id: paddler.toFirestore()});
}

Future<void> _deletePaddlerCommand(String teamID, String paddlerID) async {
  await FirebaseFirestore.instance
      .collection('teams')
      .doc(teamID)
      .collection('paddlers')
      .doc('paddlers')
      .update({paddlerID: FieldValue.delete()});
}