part of '../models/roster_model.dart';

Future<void> _setPaddlerCommand(Paddler paddler, String teamID) async {
  await getPaddlersDoc(teamID)
      .set({paddler.id: paddler.toFirestore()}, SetOptions(merge: true));
}

Future<void> _deletePaddlerCommand(String paddlerID, String teamID) async {
  await FirebaseFirestore.instance.runTransaction((transaction) async {
    final lineupsDoc = await transaction.get(getLineupsDoc(teamID));
    final lineupsData = lineupsDoc.data();

    if (lineupsData == null) return;

    // Remove paddler from lineups.
    for (MapEntry<String, dynamic> lineupEntry in lineupsData.entries) {
      final data = lineupEntry.value;
      final paddlerIDs = data['paddlerIDs'] as List;

      if (paddlerIDs.contains(paddlerID)) {
        data['paddlerIDs'] = paddlerIDs.map(
          (id) => id == paddlerID ? null : id,
        );
        transaction.update(getLineupsDoc(teamID), {lineupEntry.key: data});
      }
    }

    // Delete the paddler
    transaction
        .update(getPaddlersDoc(teamID), {paddlerID: FieldValue.delete()});
  });
}
