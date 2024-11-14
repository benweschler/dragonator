import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragonator/data/paddler.dart';

Future<void> setPaddlerCommand(Paddler paddler, String teamID) async {
  await FirebaseFirestore.instance
      .collection('teams')
      .doc(teamID)
      .collection('paddlers')
      .doc('paddlers')
      .update({paddler.id: paddler.toFirestore()});
}

Future<void> deletePaddlerCommand(String teamID, String paddlerID) async {
  await FirebaseFirestore.instance
      .collection('teams')
      .doc(teamID)
      .collection('paddlers')
      .doc('paddlers')
      .update({paddlerID: FieldValue.delete()});
}
