import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragonator/data/paddler.dart';

abstract class CreatePaddlerCommand {
  static Future<void> run(String teamID, Paddler paddler) async {
    await FirebaseFirestore.instance.collection('teams').doc(teamID).update({
      // Paddlers in Firestore have their ID as a key rather than a key-value
      // pair in their JSON definition.
      'paddlers.${paddler.id}': paddler.toJson()..remove('id')
    });
  }
}