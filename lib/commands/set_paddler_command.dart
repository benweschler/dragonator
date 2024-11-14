import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragonator/data/paddler.dart';

abstract class SetPaddlerCommand {
  static Future<void> run(Paddler paddler, String teamID) async {
    await FirebaseFirestore.instance
        .collection('teams')
        .doc(teamID)
        .collection('paddlers')
        .doc('paddlers')
        .update({
      // Paddlers in Firestore have their ID as a key rather than a key-value
      // pair in their JSON definition, they are stored within a team document
      // and so don't include a team ID.
      paddler.id: paddler.toFirestore()
    });
  }
}
