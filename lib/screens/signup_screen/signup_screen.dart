import 'package:dragonator/screens/signup_screen/field_names.dart';
import 'package:dragonator/styles/styles.dart';
import 'package:dragonator/styles/theme.dart';
import 'package:dragonator/widgets/buttons/custom_back_button.dart';
import 'package:dragonator/widgets/buttons/async_action_button.dart';
import 'package:dragonator/widgets/custom_input_decoration.dart';
import 'package:dragonator/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SignUpScreen extends StatelessWidget {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey();

  SignUpScreen({Key? key}) : super(key: key);

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
                      "Sign Up",
                      style: TextStyles.h2,
                    ),
                  ),
                  const SizedBox(height: Insets.xl),
                  Row(
                    children: [
                      Expanded(
                        child: FormBuilderTextField(
                          name: SignUpFieldNames.firstName,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          autofillHints: const [AutofillHints.givenName],
                          decoration: CustomInputDecoration(
                            appColors,
                            hintText: "First Name",
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
                          decoration: CustomInputDecoration(
                            appColors,
                            hintText: "Last Name",
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
                    autofillHints: const [AutofillHints.email],
                    decoration: CustomInputDecoration(
                      appColors,
                      hintText: "Email",
                    ),
                  ),
                  const SizedBox(height: Insets.xl),
                  FormBuilderTextField(
                    name: SignUpFieldNames.password,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.newPassword],
                    decoration: CustomInputDecoration(
                      appColors,
                      hintText: "Password",
                    ),
                  ),
                  const SizedBox(height: Insets.lg),
                  FormBuilderTextField(
                    name: SignUpFieldNames.confirmPassword,
                    obscureText: true,
                    textInputAction: TextInputAction.go,
                    autofillHints: const [AutofillHints.newPassword],
                    decoration: CustomInputDecoration(
                      appColors,
                      hintText: "Confirm Password",
                    ),
                  ),
                  const SizedBox(height: Insets.xl),
                  AsyncActionButton(
                    label: "Sign In",
                    isEnabled: true,
                    onTap: () => Future.delayed(const Duration(seconds: 1)),
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
