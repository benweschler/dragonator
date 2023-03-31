import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragonator/data/paddler.dart';

abstract class UpdatePaddlerCommand {
  static Future<void> run(Paddler paddler) async {
    final teamID = paddler.teamID;
    await FirebaseFirestore.instance.collection('teams').doc(teamID).update({
      // Paddlers in Firestore have their ID as a key rather than a key-value
      // pair in their JSON definition, they are stored within a team document
      // and so don't include a team ID.
      'paddlers.${paddler.id}': paddler.toJson()..remove('id')..remove('teamID')
    });
  }
}