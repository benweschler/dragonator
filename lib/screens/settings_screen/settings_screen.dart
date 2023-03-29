import 'package:dragonator/models/app_model.dart';
import 'package:dragonator/screens/settings_screen/change_theme_button.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/utils/iterable_utils.dart';
import 'package:dragonator/widgets/buttons/async_action_button.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Center(
        child: Consumer<AppModel>(
          builder: (context, appModel, child) {
            final user = appModel.user;
            if (user == null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  child!,
                ],
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: <Widget>[
                    const Expanded(
                      child: ChangeThemeButton(themeMode: ThemeMode.light),
                    ),
                    const Expanded(
                      child: ChangeThemeButton(themeMode: ThemeMode.dark),
                    ),
                    const Expanded(
                      child: ChangeThemeButton(themeMode: ThemeMode.system),
                    ),
                  ].separate(const SizedBox(width: Insets.sm)).toList(),
                ),
                const SizedBox(height: Insets.lg),
                Text('${user.lastName}, ${user.firstName}'),
                Text('ID: ${user.id}'),
                Text('Email: ${user.email}'),
                Text('Teams: ${user.teams}'),
                const SizedBox(height: Insets.med),
                child!,
              ],
            );
          },
          child: AsyncActionButton(
            label: 'Log Out',
            action: FirebaseAuth.instance.signOut,
            //TODO: implement error handling? not sure if it's needed
            catchError: (_) {},
          ),
        ),
      ),
    );
  }
}
