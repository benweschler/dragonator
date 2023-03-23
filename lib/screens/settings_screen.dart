import 'package:dragonator/data/app_user.dart';
import 'package:dragonator/models/app_model.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signOutButton = ResponsiveButton.large(
      onTap: FirebaseAuth.instance.signOut,
      builder: (overlay) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: Insets.xl),
          padding: const EdgeInsets.symmetric(vertical: Insets.med),
          decoration: BoxDecoration(
            borderRadius: Corners.medBorderRadius,
            color: Color.alphaBlend(
              overlay,
              AppColors.of(context).accent,
            ),
          ),
          child: Center(
            child: Text(
              'Log Out',
              style: TextStyles.body1.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );

    return Scaffold(
      body: Center(
        child: Selector<AppModel, AppUser?>(
          selector: (_, model) => model.user,
          builder: (context, user, child) {
            if(user == null) {
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
                Text('${user.lastName}, ${user.firstName}'),
                Text('ID: ${user.id}'),
                Text('Email: ${user.email}'),
                Text('Teams: ${user.teams}'),
                const SizedBox(height: Insets.med),
                child!,
              ],
            );
          },
          child: signOutButton,
        ),
      ),
    );
  }
}
