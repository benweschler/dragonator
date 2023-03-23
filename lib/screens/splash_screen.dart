import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/widgets/loading_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Splash'),
            const SizedBox(height: Insets.lg),
            const LoadingIndicator(Colors.red, size: Size.square(Insets.xl)),
            const SizedBox(height: Insets.lg),
            ElevatedButton(
              child: const Text('Log Out'),
              onPressed: () => FirebaseAuth.instance.signOut(),
            ),
          ],
        ),
      ),
    );
  }
}
