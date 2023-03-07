import 'package:dragonator/models/app_model.dart';
import 'package:dragonator/router.dart';
import 'package:dragonator/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppModel()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Dragonator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.fromType(
        context.watch<AppModel>().themeType,
      ).toThemeData(),
      routerConfig: AppRouter().router,
    );
  }
}
