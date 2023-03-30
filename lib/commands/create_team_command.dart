import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragonator/data/team.dart';

abstract class CreateTeamCommand {
  static Future<void> run(Team team) async {
    //TODO: use central firestore names
    await FirebaseFirestore.instance.collection('teams').add(
          team.toJson()
          //TODO: use manual team.toFirestore so you don't have to do this
            ..update(
              'paddlers',
              (paddlers) => Map.fromIterable(paddlers, value: (_) => {}),
            ),
        );
  }
}
