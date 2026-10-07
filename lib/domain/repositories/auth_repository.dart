import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login({required String email, required String password});

  Future<User> signUp({
    required String fullName,
    required String email,
    required String password,
  });

  Future<void> logout();

  User? get currentUser;
}
