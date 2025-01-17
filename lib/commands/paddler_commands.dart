part of '../models/roster_model.dart';

Future<void> _setPaddlerCommand(Paddler paddler, String teamID) async {
  await getPaddlersDoc(teamID)
      .set({paddler.id: paddler.toFirestore()}, SetOptions(merge: true));
}

Future<void> _deletePaddlerCommand(String paddlerID, String teamID) async {
  await getPaddlersDoc(teamID).update({paddlerID: FieldValue.delete()});
}
