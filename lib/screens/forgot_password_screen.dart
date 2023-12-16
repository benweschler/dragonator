import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/async_action_button.dart';
import 'package:dragonator/widgets/buttons/custom_back_button.dart';
import 'package:dragonator/widgets/custom_input_decoration.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _submitButtonKey = GlobalKey<AsyncActionButtonState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      leading: const CustomBackButton(),
      addScreenInset: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Insets.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Forgot Password', style: TextStyles.h2),
            const SizedBox(height: Insets.xl),
            TextField(
              controller: _emailController,
              autocorrect: false,
              enableSuggestions: false,
              onSubmitted: (_) =>
                  _submitButtonKey.currentState!.executeAction(),
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              decoration: CustomInputDecoration(
                AppColors.of(context),
                hintText: 'Email',
              ),
            ),
            const SizedBox(height: Insets.xl * 1.2),
            AsyncActionButton<FirebaseAuthException>(
              key: _submitButtonKey,
              label: 'Submit',
              //TODO: add alert dialog to notify email has been sent
              action: () => FirebaseAuth.instance.sendPasswordResetEmail(
                email: _emailController.text,
              ),
              //TODO: add error handling
              catchError: (e) => print(e),
            ),
          ],
        ),
      ),
    );
  }
}
