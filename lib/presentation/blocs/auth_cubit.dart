import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/sign_up.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required AuthRepository repository})
    : _repository = repository,
      _login = Login(repository: repository),
      _signUp = SignUp(repository: repository),
      super(const AuthInitial());

  final AuthRepository _repository;
  final Login _login;
  final SignUp _signUp;

  Future<void> checkAuthState() async {
    try {
      final user = _repository.currentUser;

      if (user == null) {
        emit(const AuthUnauthenticated());
      } else {
        emit(AuthAuthenticated(user));
      }
    } catch (error) {
      emit(AuthError(FailureMessage.fromException(error)));
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading());

    try {
      final user = await _login(email: email, password: password);

      emit(AuthAuthenticated(user));
    } catch (error) {
      emit(AuthError(FailureMessage.fromException(error)));
    }
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());

    try {
      final user = await _signUp(
        fullName: fullName,
        email: email,
        password: password,
      );

      emit(AuthAuthenticated(user));
    } catch (error) {
      emit(AuthError(FailureMessage.fromException(error)));
    }
  }

  Future<void> logout() async {
    try {
      await _repository.logout();
      emit(const AuthUnauthenticated());
    } catch (error) {
      emit(AuthError(FailureMessage.fromException(error)));
    }
  }
}
