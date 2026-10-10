class Validators {
  Validators._();

  static String? name(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Full name is required.';
    if (!RegExp(r'^[A-Z]').hasMatch(name)) {
      return 'Full Name must start with a capital letter.';
    }
    return null;
  }

  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty || !email.contains('@')) {
      return 'Please enter a valid email.';
    }
    return null;
  }

  static String? password(String? value) {
    if ((value ?? '').length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value != password) return 'Passwords do not match.';
    return null;
  }
}
