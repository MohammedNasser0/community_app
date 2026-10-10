import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUp {
  SignUp({required this._repository});

  final AuthRepository _repository;

  Future<User> call({
    required String fullName,
    required String email,
    required String password,
  }) {
    return _repository.signUp(
      fullName: fullName,
      email: email,
      password: password,
    );
  }
}
