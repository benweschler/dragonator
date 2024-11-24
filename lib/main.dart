import 'package:dragonator/models/app_model.dart';
import 'package:dragonator/router.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/models/settings_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'models/roster_model.dart';

//TODO: set preferred device orientation on android
//TODO: limit addition of fields to reasonable number for appropriate firestore documents (e.g. paddler lists, lineup lists, wherever users can create infinite of something)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final appModel = AppModel();
  final rosterModel = RosterModel();
  final settingsModel = SettingsModel();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: rosterModel),
      ChangeNotifierProvider.value(value: appModel),
      ChangeNotifierProvider.value(value: settingsModel),
    ],
    child: DragonatorApp(AppRouter(appModel).router),
  ));
}

class DragonatorApp extends StatelessWidget {
  final RouterConfig<Object> router;

  const DragonatorApp(this.router, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _resolveIsDark(context)
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: MaterialApp.router(
        title: 'Dragonator',
        debugShowCheckedModeBanner: false,
        theme: AppColors.fromType(
          context.select<SettingsModel, ThemeType>(
            (model) => model.lightThemeType,
          ),
        ).toThemeData(),
        darkTheme: AppColors.fromType(
          context.select<SettingsModel, ThemeType>(
            (model) => model.darkThemeType,
          ),
        ).toThemeData(),
        routerConfig: router,
      ),
    );
  }

  /// Whether the app's current theme is dark.
  bool _resolveIsDark(BuildContext context) {
    switch (context.select<SettingsModel, ThemeMode>(
      (model) => model.themeMode,
    )) {
      case ThemeMode.system:
        return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
      case ThemeMode.light:
        return false;
      case ThemeMode.dark:
        return true;
    }
  }
}
