/// Form field validators shared by the auth screens.
abstract final class Validators {
  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? email(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Email is required.';
    if (!_emailPattern.hasMatch(trimmed)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  static String? password(String? value) =>
      (value ?? '').isEmpty ? 'Password is required.' : null;

  /// Firebase requires 6+ characters for new passwords.
  static String? newPassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Password is required.';
    if (password.length < 6) return 'Use at least 6 characters.';
    return null;
  }

  static String? confirmPassword(String? value, String original) =>
      value != original ? 'Passwords do not match.' : null;

  static String? requiredField(String? value, {String label = 'This field'}) =>
      (value?.trim() ?? '').isEmpty ? '$label is required.' : null;
}
