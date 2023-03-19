import 'package:dragonator/screens/login_screen/login_errors.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/loading_button_content.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:dragonator/widgets/loading_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatefulWidget {
  final bool isEnabled;
  final Future<UserCredential> Function() logIn;
  final void Function(String) onError;

  const LoginButton({
    Key? key,
    required this.isEnabled,
    required this.logIn,
    required this.onError,
  }) : super(key: key);

  @override
  State<LoginButton> createState() => LoginButtonState();
}

class LoginButtonState extends State<LoginButton> {
  bool isLoading = false;

  Future<void> logIn() async {
    setState(() => isLoading = true);
    try {
      await widget
          .logIn()
          .whenComplete(() => setState(() => isLoading = false));
    } on FirebaseAuthException catch (error) {
      print(error.code);
      if (error.code == "network-request-failed") {
        widget.onError(LoginErrors.networkError);
      } else {
        widget.onError(LoginErrors.invalidLogin);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = AppColors.of(context).accent;

    return IgnorePointer(
      ignoring: !widget.isEnabled || isLoading,
      child: ResponsiveButton.large(
        onTap: logIn,
        builder: (overlay) => Container(
          padding: const EdgeInsets.all(Insets.med),
          decoration: BoxDecoration(
            borderRadius: Corners.medBorderRadius,
            color: widget.isEnabled
                ? Color.alphaBlend(overlay, buttonColor)
                : buttonColor.withOpacity(0.5),
          ),
          child: LoadingButtonContent(
            isLoading: isLoading,
            loadingIndicator: const LoadingIndicator(Colors.white),
            label: Text(
              "Log In",
              style: TextStyles.body1.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
