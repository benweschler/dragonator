import 'package:dragonator/screens/signup_screen/field_names.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/utils/validators.dart';
import 'package:dragonator/widgets/buttons/custom_back_button.dart';
import 'package:dragonator/widgets/buttons/async_action_button.dart';
import 'package:dragonator/widgets/custom_input_decoration.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SignUpScreen extends StatelessWidget {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey();

  SignUpScreen({Key? key}) : super(key: key);

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

    final pairedFieldIsFilled = null ==
        Validators.required().call(
          _formKey.currentState!.fields[pairedFieldName]!.value,
        );

    String? errorText =
        pairedFieldIsFilled ? unPairedErrorText : pairedErrorText;

    return Validators.required(
      errorText: errorText,
    ).call(value);
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors.of(context);

    return CustomScaffold(
      leading: const CustomBackButton(),
      child: Center(
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            child: AutofillGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            appColors,
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
                            appColors,
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
                      appColors,
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
                      appColors,
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
                      appColors,
                      hintText: 'Confirm Password',
                    ),
                  ),
                  const SizedBox(height: Insets.xl * 1.5),
                  AsyncActionButton(
                    label: 'Sign Up',
                    isEnabled: true,
                    action: () async {
                      await Future.delayed(const Duration(seconds: 1));
                      _formKey.currentState!.saveAndValidate();
                    },
                    catchError: (_) {},
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
