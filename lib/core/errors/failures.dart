import 'package:firebase_auth/firebase_auth.dart';

class FailureMessage {
  FailureMessage._();

  static String fromException(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
          return 'Email or password is incorrect.';
        case 'email-already-in-use':
          return 'This email is already registered.';
        case 'weak-password':
          return 'Please choose a stronger password.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'network-request-failed':
          return 'Network error. Check your connection and try again.';
        default:
          return error.message ?? 'Authentication failed. Please try again.';
      }
    }

    final message = error.toString();
    if (message.contains('permission-denied')) {
      return 'You do not have permission to perform this action.';
    }
    return message.replaceFirst('Exception: ', '');
  }
}
