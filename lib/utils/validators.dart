import 'package:form_builder_validators/form_builder_validators.dart';

abstract class Validators {
  /// Checks if the field value is non-empty.
  ///
  /// An empty value is either null, the empty String, or an empty Iterable or
  /// Map.
  static String? Function(T?) required<T>({String? errorText}) =>
      FormBuilderValidators.required<T>(errorText: errorText ?? '');

  /// Checks if the field value is equal to [other] and is non-empty;
  static String? Function(T?) equals<T extends Object>(T? other,
          {String? errorText}) =>
      (value) => required().call(value) != null || value != other
          ? errorText ?? ''
          : null;

  /// Checks if the field value is an integer and non-empty.
  static String? Function(String?) isInt({String? errorText}) =>
      (value) => required().call(value) != null || int.tryParse(value!) == null
          ? errorText ?? ''
          : null;

  /// Checks if the field value is an email and is non-empty.
  //TODO: this validator is not as rigorous as firebase's validator
  static String? Function(String?) email({String? errorText}) => (value) {
        if (required().call(value) != null) return errorText ?? '';
        return FormBuilderValidators.email(errorText: errorText ?? '')
            .call(value);
      };

  /// Checks if the field is equal to [password].
  ///
  /// Does not fire if [password] is empty with the assumption that the password
  /// field will show an error.
  /// This must be wrapped in a callback in order to get the current password
  /// from a form field state.
  static String? Function(String?) confirmPassword(String? password,
          {String? errorText}) =>
      (value) {
        // Only show an error if a password has been entered.
        if (!(Validators.required().call(password) == null)) return null;
        return Validators.equals(
          password,
          errorText: 'Passwords do not match',
        ).call(value);
      };
}
