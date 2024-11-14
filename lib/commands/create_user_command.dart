import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragonator/data/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class CreateUserCommand {
  static Future<void> run({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final firebaseAuth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;

    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final AppUser user = AppUser(
      id: userCredential.user!.uid,
      firstName: firstName,
      lastName: lastName,
      email: email,
      teamIDs: [],
    );

    await firestore.collection('users').doc(user.id).set(user.toJson());
  }
}
