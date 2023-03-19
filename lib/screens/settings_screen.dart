import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(FirebaseAuth.instance.currentUser!.displayName ??
                "No Display Name"),
            Text(FirebaseAuth.instance.currentUser!.uid),
            Text(FirebaseAuth.instance.currentUser!.email ?? "No Email"),
            const SizedBox(height: Insets.med),
            ResponsiveButton.large(
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
                      "Log Out",
                      style: TextStyles.body1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
