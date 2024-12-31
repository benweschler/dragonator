import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/validators.dart';
import 'package:dragonator/widgets/buttons/async_action_button.dart';
import 'package:dragonator/widgets/buttons/custom_back_button.dart';
import 'package:dragonator/widgets/custom_input_decoration.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:dragonator/widgets/error_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _submitButtonKey = GlobalKey<AsyncActionButtonState>();
  final ValueNotifier<String?> _errorNotifier = ValueNotifier(null);

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
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _emailController,
                autocorrect: false,
                enableSuggestions: false,
                onFieldSubmitted: (_) =>
                    _submitButtonKey.currentState!.executeAction(),
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                autovalidateMode: AutovalidateMode.onUnfocus,
                validator: Validators.email(errorText: 'Enter a valid email.'),
                decoration: CustomInputDecoration(
                  AppColors.of(context),
                  hintText: 'Email',
                ),
              ),
            ),
            ValueListenableBuilder<String?>(
              valueListenable: _errorNotifier,
              builder: (_, error, __) => Column(
                children: error == null ? [] : [
                  const SizedBox(height: Insets.lg),
                  ErrorCard(error),
                ],
              ),
            ),
            const SizedBox(height: Insets.xl * 1.2),
            ListenableBuilder(
              listenable: _emailController,
              builder: (context, _) => AsyncActionButton<FirebaseAuthException>(
                key: _submitButtonKey,
                label: 'Submit',
                enabled: _emailController.text.isNotEmpty,
                //TODO: add alert dialog to notify email has been sent
                action: () async {
                  if (!_formKey.currentState!.validate()) return;

                  return FirebaseAuth.instance.sendPasswordResetEmail(
                    email: _emailController.text,
                  );
                },
                //TODO: add error handling
                catchError: (error) => _errorNotifier.value = error.message,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _ErrorCodes {
  invalidEmail('invalid-email'),
  userNotFound('user-not-found');

  final String code;

  const _ErrorCodes(this.code);
}
