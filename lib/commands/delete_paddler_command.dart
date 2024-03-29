import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DeletePaddlerCommand {
  static Future<void> run(String teamID, String paddlerID) async {
    FirebaseFirestore.instance.collection('teams').doc(teamID).update({
      'paddlers.$paddlerID' : FieldValue.delete(),
    });
  }
}