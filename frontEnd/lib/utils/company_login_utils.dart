String? validateCompanyLoginInputs({
  required String companyName,
  required String email,
  required String password,
}) {
  if (companyName.trim().isEmpty ||
      email.trim().isEmpty ||
      password.trim().isEmpty) {
    return 'Please enter Company Name, Email and Password';
  }

  return null;
}

String mapCompanyLoginErrorCode(String code, {String? fallbackMessage}) {
  switch (code) {
    case 'user-not-found':
      return 'No user found for that email.';
    case 'wrong-password':
    case 'invalid-credential':
      return 'Wrong email or password.';
    case 'too-many-requests':
      return 'Too many attempts. Please try again later.';
    default:
      return (fallbackMessage != null && fallbackMessage.trim().isNotEmpty)
          ? fallbackMessage
          : 'Authentication failed';
  }
}

String mapResetPasswordErrorCode(String code) {
  switch (code) {
    case 'user-not-found':
      return 'No account found with that email.';
    case 'invalid-email':
      return 'Please enter a valid email address.';
    case 'too-many-requests':
      return 'Too many attempts. Please try again later.';
    default:
      return 'Failed to send reset email.';
  }
}
