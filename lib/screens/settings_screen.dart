import 'package:dragonator/data/app_user.dart';
import 'package:dragonator/models/app_model.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/async_action_button.dart';
import 'package:dragonator/widgets/buttons/custom_icon_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Selector<AppModel, AppUser?>(
          selector: (_, model) => model.user,
          builder: (context, user, child) {
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconButton(
                      onTap: () =>
                          context.read<AppModel>().themeType = ThemeType.light,
                      icon: Icons.light_mode_rounded,
                    ),
                    const SizedBox(width: Insets.med),
                    CustomIconButton(
                      onTap: () =>
                          context.read<AppModel>().themeType = ThemeType.dark,
                      icon: Icons.dark_mode_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: Insets.med),
                Text('${user.lastName}, ${user.firstName}'),
                Text('ID: ${user.id}'),
                Text('Email: ${user.email}'),
                Text('Teams: ${user.teams}'),
                const SizedBox(height: Insets.med),
                child!,
              ],
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Insets.xl),
            child: AsyncActionButton(
              label: 'Log Out',
              action: FirebaseAuth.instance.signOut,
              //TODO: implement error handling? not sure if it's needed
              catchError: (_) {},
            ),
          ),
        ),
      ),
    );
  }
}
