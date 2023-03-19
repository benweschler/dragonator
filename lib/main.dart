import 'package:dragonator/models/app_model.dart';
import 'package:dragonator/router.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/dummy_data.dart';
import 'firebase_options.dart';
import 'models/roster_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //TODO: set preferred device orientation on ios and android

  final appModel  = AppModel();

  final rosterModel = RosterModel();

  assignDummyData(rosterModel);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: rosterModel),
      ChangeNotifierProvider.value(value: appModel),
    ],
    child: MyApp(AppRouter().router),
  ));
}

class MyApp extends StatelessWidget {
  final RouterConfig<Object> router;

  const MyApp(this.router, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Dragonator',
      debugShowCheckedModeBanner: false,
      theme: AppColors.fromType(
        context.watch<AppModel>().themeType,
      ).toThemeData(),
      routerConfig: router,
    );
  }
}
