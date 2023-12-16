import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: LoadingIndicator(Colors.red, size: Size.square(Insets.xl)),
      ),
    );
  }
}
