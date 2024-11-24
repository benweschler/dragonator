part of '../models/roster_model.dart';

Future<Map<String, dynamic>> _getTeamPaddlersCommand(
  String currentTeamID,
) async {
  final paddlersSnapshot = await getPaddlersDoc(currentTeamID).get();
  return paddlersSnapshot.data() ?? {};
}

Future<void> _setPaddlerCommand(Paddler paddler, String teamID) async {
  await getPaddlersDoc(teamID)
      .set({paddler.id: paddler.toFirestore()}, SetOptions(merge: true));
}

Future<void> _deletePaddlerCommand(String paddlerID, String teamID,) async {
  await getPaddlersDoc(teamID).update({paddlerID: FieldValue.delete()});
}
