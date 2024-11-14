import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragonator/data/paddler.dart';

abstract class GetPaddlerCommand {
  static Future<Paddler> run(String paddlerID, String teamID) async {
    final paddlerDocSnapshot = await FirebaseFirestore.instance
        .collection('teams')
        .doc(teamID)
        .collection('paddlers')
        .doc('paddlers')
        .get();

    final Map<String, Map<String, dynamic>> paddlerData =
        paddlerDocSnapshot.data()!['paddlers']!;

    return Paddler.fromFirestore(id: paddlerID, data: paddlerData[paddlerID]!);
  }
}
