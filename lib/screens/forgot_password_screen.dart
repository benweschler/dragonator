import 'package:dragonator/router.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/navigation_utils.dart';
import 'package:dragonator/utils/validators.dart';
import 'package:dragonator/widgets/buttons/async_action_button.dart';
import 'package:dragonator/widgets/buttons/custom_back_button.dart';
import 'package:dragonator/widgets/buttons/expanding_buttons.dart';
import 'package:dragonator/widgets/custom_input_decoration.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:dragonator/widgets/error_card.dart';
import 'package:dragonator/widgets/popups/popup_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
                children: error == null
                    ? []
                    : [
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
                action: () async {
                  if (!_formKey.currentState!.validate()) return;

                  return FirebaseAuth.instance.sendPasswordResetEmail(
                    email: _emailController.text,
                  ).then((_) {
                    if (!context.mounted) return;
                    context.showPopup(
                      barrierDismissible: false,
                      _PasswordResetConfirmationPopup(
                        _emailController.text,
                      ),
                    );
                  });
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

class _PasswordResetConfirmationPopup extends StatelessWidget {
  final String email;

  const _PasswordResetConfirmationPopup(this.email);

  @override
  Widget build(BuildContext context) {
    return PopupDialog(
      child: Padding(
        padding: EdgeInsets.all(Insets.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Password Reset Sent', style: TextStyles.title1),
            const SizedBox(height: Insets.med),
            Text.rich(TextSpan(children: [
              TextSpan(
                text: 'If there is an account associated with the email ',
              ),
              TextSpan(
                  text: email,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                text:
                    ' we\'ve sent an email with instructions to reset your password.  If you don’t see the email, check your spam or junk folder.',
              ),
            ])),
            const SizedBox(height: Insets.xl),
            ExpandingStadiumButton(
              onTap: () => context.go(RoutePaths.logIn),
              color: AppColors.of(context).primary,
              label: 'Confirm',
            ),
            SizedBox(height: Insets.sm),
          ],
        ),
      ),
    );
  }
}
