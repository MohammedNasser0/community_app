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
  Future<User?> getUser(String userId);
  Future<User?> updateProfileImage({
    required String userId,
    required List<int> bytes,
  });
}
