//TODO: set preferred device orientation on android
import 'package:dragonator/models/app_model.dart';
import 'package:dragonator/router.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'data/dummy_data.dart';
import 'firebase_options.dart';
import 'models/roster_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final appModel = AppModel();

  final rosterModel = RosterModel();

  assignDummyData(rosterModel);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: rosterModel),
      ChangeNotifierProvider.value(value: appModel),
    ],
    child: MyApp(AppRouter(appModel).router),
  ));
}

class MyApp extends StatelessWidget {
  final RouterConfig<Object> router;

  const MyApp(this.router, {super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors.fromType(context.watch<AppModel>().themeType);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: appColors.isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: MaterialApp.router(
        title: 'Dragonator',
        debugShowCheckedModeBanner: false,
        theme: appColors.toThemeData(),
        routerConfig: router,
      ),
    );
  }
}
