import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:dragonator/widgets/custom_input_decoration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _loginButtonKey = GlobalKey<LoginButtonState>();
  String? errorMessage;
  bool areCredentialsEntered = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void updateAreCredentialsEntered() {
    setState(() => areCredentialsEntered = _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors.of(context);

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: Insets.xl),
        child: AutofillGroup(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Text(
                  "Log In",
                  style: TextStyles.h2,
                ),
              ),
              const SizedBox(height: Insets.xl),
              TextField(
                controller: _emailController,
                autocorrect: false,
                enableSuggestions: false,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => updateAreCredentialsEntered(),
                autofillHints: const [AutofillHints.email],
                decoration: CustomInputDecoration(
                  appColors,
                  hintText: "Email",
                ),
              ),
              const SizedBox(height: Insets.lg),
              TextField(
                controller: _passwordController,
                obscureText: true,
                textInputAction: TextInputAction.go,
                onChanged: (_) => updateAreCredentialsEntered(),
                onSubmitted: (_) => _loginButtonKey.currentState!.logIn(),
                autofillHints: const [AutofillHints.password],
                decoration: CustomInputDecoration(
                  appColors,
                  hintText: "Password",
                ),
              ),
              if (errorMessage != null) ...[
                const SizedBox(height: Insets.lg),
                ErrorCard(errorMessage!),
              ],
              const SizedBox(height: Insets.xl * 1.2),
              LoginButton(
                key: _loginButtonKey,
                // Do not allow a login attempt if credentials have not been
                // entered.
                isEnabled: areCredentialsEntered,
                logIn: () => FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                ),
                onError: (error) => setState(() => errorMessage = error),
              ),
              const SizedBox(height: Insets.sm),
              const SignUpButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpButton extends StatelessWidget {
  const SignUpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveButton.large(
      onTap: () {},
      builder: (overlay) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Insets.med),
          child: Text(
            "Sign Up",
            style: TextStyles.body1.copyWith(
              color: Color.alphaBlend(overlay, AppColors.of(context).accent),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class ErrorCard extends StatelessWidget {
  final String message;

  const ErrorCard(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorColor = AppColors.of(context).accent;

    return Container(
      padding: const EdgeInsets.all(Insets.sm),
      decoration: BoxDecoration(
        borderRadius: Corners.medBorderRadius,
        color: errorColor.withOpacity(0.08),
        border: Border.all(color: errorColor.withOpacity(0.65)),
      ),
      child: Text(
        message,
        style: TextStyles.body2.copyWith(
          fontWeight: FontWeight.w500,
          color: errorColor.withOpacity(0.65),
        ),
      ),
    );
  }
}
