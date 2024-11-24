import 'package:dragonator/commands/firestore_references.dart';
import 'package:dragonator/data/user/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> createUserCommand({
  required String firstName,
  required String lastName,
  required String email,
  required String password,
}) async {
  final firebaseAuth = FirebaseAuth.instance;

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

  await getUserDoc(user.id).set(user.toJson());
}

Future<AppUser> getUserCommand(String userID) async {
  final snapshot = await getUserDoc(userID).get();
  Map<String, dynamic> userData = snapshot.data()!;

  return AppUser.fromJson(userData);
}