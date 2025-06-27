import 'package:firebase_auth/firebase_auth.dart';

String? getErrorMessageFromCode(String code, FirebaseAuthException e) {
  switch (code) {
    case 'invalid-credential':
      return 'Invalid email or password';
    case 'email-already-in-use':
      return 'Email already in use.';
    default:
      return e.message ?? 'Something went wrong. Please try again later.';
  }
}
