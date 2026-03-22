import 'package:archisri_1/utils/company_login_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('validateCompanyLoginInputs', () {
    test('returns validation message when fields are empty', () {
      final result = validateCompanyLoginInputs(
        companyName: '',
        email: 'x@x.com',
        password: 'abc',
      );

      expect(result, 'Please enter Company Name, Email and Password');
    });

    test('treats whitespace-only values as empty', () {
      final result = validateCompanyLoginInputs(
        companyName: '   ',
        email: '   ',
        password: '   ',
      );

      expect(result, 'Please enter Company Name, Email and Password');
    });

    test('returns null for valid input values', () {
      final result = validateCompanyLoginInputs(
        companyName: 'BuildPro',
        email: 'company@email.com',
        password: 'secret123',
      );

      expect(result, isNull);
    });
  });

  group('mapCompanyLoginErrorCode', () {
    test('maps known auth error codes to user-friendly messages', () {
      expect(
        mapCompanyLoginErrorCode('user-not-found'),
        'No user found for that email.',
      );
      expect(
        mapCompanyLoginErrorCode('wrong-password'),
        'Wrong email or password.',
      );
      expect(
        mapCompanyLoginErrorCode('invalid-credential'),
        'Wrong email or password.',
      );
      expect(
        mapCompanyLoginErrorCode('too-many-requests'),
        'Too many attempts. Please try again later.',
      );
    });

    test('uses fallback message for unknown code when provided', () {
      final result = mapCompanyLoginErrorCode(
        'internal-error',
        fallbackMessage: 'Server unavailable',
      );

      expect(result, 'Server unavailable');
    });

    test(
      'returns default generic message for unknown code without fallback',
      () {
        final result = mapCompanyLoginErrorCode('internal-error');

        expect(result, 'Authentication failed');
      },
    );
  });

  group('mapResetPasswordErrorCode', () {
    test('maps known reset-password error codes', () {
      expect(
        mapResetPasswordErrorCode('user-not-found'),
        'No account found with that email.',
      );
      expect(
        mapResetPasswordErrorCode('invalid-email'),
        'Please enter a valid email address.',
      );
      expect(
        mapResetPasswordErrorCode('too-many-requests'),
        'Too many attempts. Please try again later.',
      );
    });

    test('returns default reset-password failure for unknown code', () {
      expect(
        mapResetPasswordErrorCode('something-else'),
        'Failed to send reset email.',
      );
    });
  });
}
