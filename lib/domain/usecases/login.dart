import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class Login {
  Login({required AuthRepository repository}) : _repository = repository;

  final AuthRepository _repository;

  Future<User> call({required String email, required String password}) {
    return _repository.login(email: email, password: password);
  }
}
