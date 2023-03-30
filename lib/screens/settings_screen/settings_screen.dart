import 'package:dragonator/data/app_user.dart';
import 'package:dragonator/models/app_model.dart';
import 'package:dragonator/screens/settings_screen/change_theme_button.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
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
          builder: (_, model, themeButtonRow) {
            final user = model.user;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Profile', style: TextStyles.h2),
                const SizedBox(height: Insets.sm),
                ProfileInfo(user),
                const SizedBox(height: Insets.xl),
                const Text('Theme', style: TextStyles.h2),
                const SizedBox(height: Insets.sm),
                themeButtonRow!,
                const SizedBox(height: Insets.lg),
                const Text('Teams', style: TextStyles.h2),
                const SizedBox(height: Insets.med),
                AsyncActionButton(
                  label: 'Log Out',
                  action: FirebaseAuth.instance.signOut,
                  //TODO: implement error handling? not sure if it's needed
                  catchError: (_) {},
                ),
              ],
            );
          },
          child: Row(
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
        ),
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  final AppUser user;

  const ProfileInfo(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name',
                style: TextStyles.caption.copyWith(
                  color: AppColors.of(context).neutralContent,
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '${user.firstName} ${user.lastName}',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: Insets.xl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Email',
                  style: TextStyles.caption.copyWith(
                    color: AppColors.of(context).neutralContent,
                  ),
                ),
                Text(user.email),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
