import 'package:dragonator/router.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/async_action_button.dart';
import 'package:dragonator/widgets/buttons/responsive_buttons.dart';
import 'package:dragonator/widgets/custom_input_decoration.dart';
import 'package:dragonator/widgets/error_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'login_errors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginButtonKey = GlobalKey<AsyncActionButtonState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? errorMessage;
  bool areCredentialsEntered = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> logIn() async {
    // Do not allow a login attempt if credentials have not been
    // entered.
    if (!areCredentialsEntered) return;

    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  void catchLoginError(FirebaseAuthException error) {
    if (error.code == 'network-request-failed') {
      setState(() => errorMessage = LoginErrors.networkError);
    } else {
      setState(() => errorMessage = LoginErrors.invalidLogin);
    }
  }

  void updateAreCredentialsEntered() {
    setState(() => areCredentialsEntered = _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors.of(context);

    // No need for a [CustomScaffold] since neither the app bar nor a screen
    // offset is used.
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: Insets.xl),
        child: AutofillGroup(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text('Log In', style: TextStyles.h2),
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
                      hintText: 'Email',
                    ),
                  ),
                  const SizedBox(height: Insets.lg),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    textInputAction: TextInputAction.go,
                    onChanged: (_) => updateAreCredentialsEntered(),
                    onSubmitted: (_) =>
                        _loginButtonKey.currentState!.executeAction(),
                    autofillHints: const [AutofillHints.password],
                    decoration: CustomInputDecoration(
                      appColors,
                      hintText: 'Password',
                    ),
                  ),
                  const SizedBox(height: Insets.sm),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ResponsiveStrokeButton(
                      onTap: () => context.go(RoutePaths.forgotPassword),
                      child: Text(
                        'Forgot Password',
                        style: TextStyles.body2.copyWith(
                          color: AppColors.of(context).accent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  if (errorMessage != null) ...[
                    const SizedBox(height: Insets.lg),
                    ErrorCard(errorMessage!),
                  ],
                  const SizedBox(height: Insets.xl * 1.2),
                  AsyncActionButton<FirebaseAuthException>(
                    key: _loginButtonKey,
                    label: 'Log In',
                    isEnabled: areCredentialsEntered,
                    action: logIn,
                    catchError: catchLoginError,
                  ),
                  const SizedBox(height: Insets.sm),
                  const GoToSignUpButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GoToSignUpButton extends StatelessWidget {
  const GoToSignUpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveStrokeButton(
      // Go must be used in order to play a page transition animation when
      // navigating back to the login screen.
      onTap: () => context.push(RoutePaths.signUp),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Insets.med),
          child: Text(
            'Sign Up',
            style: TextStyles.body1.copyWith(
              color: AppColors.of(context).accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
