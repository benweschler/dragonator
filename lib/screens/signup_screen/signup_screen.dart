import 'package:dragonator/commands/user_commands.dart';
import 'package:dragonator/models/app_model.dart';import 'package:dragonator/screens/signup_screen/field_names.dart';
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
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey();
  final ValueNotifier<String?> _errorNotifier = ValueNotifier(null);
  final GlobalKey<AsyncActionButtonState> _signUpButtonKey = GlobalKey();

  SignUpScreen({super.key});

  Future<void> signUp(AppModel appModel) async {
    final formData = _formKey.currentState!.value;

    await createUserCommand(
      firstName: formData[SignUpFieldNames.firstName],
      lastName: formData[SignUpFieldNames.lastName],
      email: formData[SignUpFieldNames.email],
      password: formData[SignUpFieldNames.password],
    );
  }

  /// Removes an error from both name fields when either name field is edited in
  /// an error state.
  void _onNameFieldChanged(String? fieldName) {
    final pairedFieldName = fieldName == SignUpFieldNames.firstName
        ? SignUpFieldNames.lastName
        : SignUpFieldNames.firstName;

    final thisField = _formKey.currentState!.fields[fieldName]!;
    final pairedField = _formKey.currentState!.fields[pairedFieldName]!;
    if (thisField.hasError && pairedField.hasError) {
      pairedField.reset();
    }
  }

  /// Assigns name fields a shared error message when both have an error and an
  /// individual error message when only one has an error.
  String? _validateNameField({
    String? value,
    String? fieldName,
    String? unPairedErrorText,
    String? pairedErrorText,
  }) {
    final pairedFieldName = fieldName == SignUpFieldNames.firstName
        ? SignUpFieldNames.lastName
        : SignUpFieldNames.firstName;

    final pairedFieldHasError =
        _formKey.currentState!.fields[pairedFieldName]!.hasError;

    String? errorText =
        pairedFieldHasError ? pairedErrorText : unPairedErrorText;

    return Validators.required(
      errorText: errorText,
    ).call(value);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      leading: const CustomBackButton(),
      child: Center(
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            child: AutofillGroup(
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      'Sign Up',
                      style: TextStyles.h2,
                    ),
                  ),
                  const SizedBox(height: Insets.xl),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: FormBuilderTextField(
                          name: SignUpFieldNames.firstName,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          autofillHints: const [AutofillHints.givenName],
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => _validateNameField(
                            value: value,
                            fieldName: SignUpFieldNames.firstName,
                            unPairedErrorText: 'Enter your first name',
                            pairedErrorText: 'Enter your name',
                          ),
                          onChanged: (_) => _onNameFieldChanged(
                            SignUpFieldNames.firstName,
                          ),
                          decoration: CustomInputDecoration(
                            AppColors.of(context),
                            hintText: 'First Name',
                          ),
                        ),
                      ),
                      const SizedBox(width: Insets.med),
                      Expanded(
                        child: FormBuilderTextField(
                          name: SignUpFieldNames.lastName,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          autofillHints: const [AutofillHints.familyName],
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (_) => _onNameFieldChanged(
                            SignUpFieldNames.lastName,
                          ),
                          validator: (value) => _validateNameField(
                            value: value,
                            fieldName: SignUpFieldNames.lastName,
                            unPairedErrorText: 'Enter your last name',
                            pairedErrorText: null,
                          ),
                          decoration: CustomInputDecoration(
                            AppColors.of(context),
                            hintText: 'Last Name',
                            showEmptyErrorText: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Insets.xl),
                  FormBuilderTextField(
                    name: SignUpFieldNames.email,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    autofillHints: const [AutofillHints.email],
                    validator: Validators.email(
                      errorText: 'Enter a valid email',
                    ),
                    decoration: CustomInputDecoration(
                      AppColors.of(context),
                      hintText: 'Email',
                    ),
                  ),
                  const SizedBox(height: Insets.xl),
                  FormBuilderTextField(
                    name: SignUpFieldNames.password,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.newPassword],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: Validators.required(
                      errorText: 'Enter a password',
                    ),
                    decoration: CustomInputDecoration(
                      AppColors.of(context),
                      hintText: 'Password',
                    ),
                  ),
                  const SizedBox(height: Insets.lg),
                  FormBuilderTextField(
                    name: SignUpFieldNames.confirmPassword,
                    obscureText: true,
                    textInputAction: TextInputAction.go,
                    autofillHints: const [AutofillHints.newPassword],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSubmitted: (_) =>
                        _signUpButtonKey.currentState!.executeAction(),
                    // Wrap the validator inside of the callback to pass an
                    // up-to-date password value.
                    validator: (value) {
                      return Validators.confirmPassword(
                        _formKey.currentState
                            ?.fields[SignUpFieldNames.password]!.value,
                        errorText: 'Passwords do not match',
                      ).call(value);
                    },
                    decoration: CustomInputDecoration(
                      AppColors.of(context),
                      hintText: 'Confirm Password',
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
                  AsyncActionButton<FirebaseAuthException>(
                    key: _signUpButtonKey,
                    label: 'Sign Up',
                    action: () async {
                      if (!_formKey.currentState!.saveAndValidate()) {
                        return;
                      }
                      return signUp(context.read<AppModel>());
                    },
                    //TODO: add error handling
                    catchError: (error) => _errorNotifier.value = error.message,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
