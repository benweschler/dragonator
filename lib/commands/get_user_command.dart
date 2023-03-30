import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragonator/data/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

//TODO: add realtime listening
abstract class GetUserCommand {
  static Future<AppUser> run(User user) async {
    final firestore = FirebaseFirestore.instance;

    final snapshot = await firestore.collection('users').doc(user.uid).get();
    Map<String, dynamic> userData = snapshot.data()!;

    return AppUser.fromJson(userData);
  }
}