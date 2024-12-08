import 'package:dragonator/bootstrapper.dart';
import 'package:dragonator/models/app_model.dart';
import 'package:dragonator/models/roster_model.dart';
import 'package:dragonator/models/settings_model.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Must initialize app with a context that includes a navigator.
    Bootstrapper(
      appModel: context.read<AppModel>(),
      rosterModel: context.read<RosterModel>(),
      settingsModel: context.read<SettingsModel>(),
    ).initializeApp(Navigator.of(context, rootNavigator: true).context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: LoadingIndicator(Colors.red, size: Size.square(Insets.xl)),
      ),
    );
  }
}
