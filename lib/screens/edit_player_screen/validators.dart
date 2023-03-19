abstract class Validators {
  /// Checks if [value] is [null].
  ///
  /// For use on a selector, where either a value is selected or no value is
  /// selected.
  static String? hasSelection<T>(T? value) => value == null ? "" : null;

  /// Checks if [value] is null or the empty string.
  ///
  /// For use on a text field, where an empty field can either contain [null] or
  /// the empty string.
  static String? hasText(String? value) => value?.isEmpty ?? true ? "" : null;
}
