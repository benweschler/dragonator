import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragonator/data/paddler.dart';

abstract class CreatePaddlerCommand {
  static Future<void> run(String teamID, Paddler paddler) async {
    //TODO: use central firestore names
    await FirebaseFirestore.instance.collection('teams').doc(teamID).update({
      // Paddlers in Firestore have their ID as a key rather than a key-value
      // pair in their JSON definition.
      //TODO: use manual player.toFirestore so you don't have to do this
      'paddlers.${paddler.id}': paddler.toJson()..remove('id')
    });
  }
}