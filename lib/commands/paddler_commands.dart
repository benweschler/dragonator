part of '../models/roster_model.dart';

Future<void> _setPaddlerCommand(Paddler paddler, String teamID) async {
  await getPaddlersDoc(teamID)
      .set({paddler.id: paddler.toFirestore()}, SetOptions(merge: true));
}

Future<void> _deletePaddlerCommand(
  String paddlerID,
  String teamID,
  Iterable<Lineup> lineups,
) async {
  final batch = FirebaseFirestore.instance.batch();

  await getPaddlersDoc(teamID).update({paddlerID: FieldValue.delete()});

  for (Lineup lineup in lineups) {
    if (lineup.paddlerIDs.contains(paddlerID)) {
      final updatedLineup = lineup.copyWith(
        paddlerIDs: lineup.paddlerIDs.map((id) => id == paddlerID ? null : id),
      );
      batch.update(
        getLineupsDoc(teamID),
        {lineup.id: updatedLineup.toFirestore()},
      );
    }
  }

  batch.update(getPaddlersDoc(teamID), {paddlerID: FieldValue.delete()});

  return batch.commit();
}
