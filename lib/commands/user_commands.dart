import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragonator/data/user/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> createUserCommand({
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

  final user = AppUser(
    id: userCredential.user!.uid,
    firstName: firstName,
    lastName: lastName,
    email: email,
  );

  await firestore.collection('users').doc(user.id).set(user.toJson());
}

Future<AppUser> getUserCommand(String userID) async {
  final firestore = FirebaseFirestore.instance;

  final snapshot = await firestore.collection('users').doc(userID).get();
  Map<String, dynamic> userData = snapshot.data()!;

  return AppUser.fromJson(userData);
}