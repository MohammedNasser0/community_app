import 'package:firebase_auth/firebase_auth.dart';

class FailureMessage {
  static String fromException(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'Please enter a valid email address.';

        case 'user-not-found':
          return 'No account was found with this email.';

        case 'wrong-password':
        case 'invalid-credential':
          return 'Email or password is incorrect.';

        case 'email-already-in-use':
          return 'This email is already registered.';

        case 'weak-password':
          return 'Password is too weak. Use at least 6 characters.';

        case 'network-request-failed':
          return 'Please check your internet connection.';

        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';

        default:
          return 'Authentication failed. Please try again.';
      }
    }

    return 'Something went wrong. Please try again.';
  }
}
