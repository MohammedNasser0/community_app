import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/sign_up.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this._repository,
    required this._login,
    required this._signUp,
  }) : super(const AuthInitial());

  final AuthRepository _repository;
  final Login _login;
  final SignUp _signUp;

  Future<void> checkAuthState() async {
    try {
      final firebaseUser = _repository.currentUser;
      if (firebaseUser == null) {
        emit(const AuthUnauthenticated());
        return;
      }
      final stored = await _repository.getUser(firebaseUser.id);
      emit(AuthAuthenticated(stored ?? firebaseUser));
    } catch (error) {
      emit(AuthError(FailureMessage.fromException(error)));
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading());
    try {
      emit(AuthAuthenticated(await _login(email: email, password: password)));
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
      emit(
        AuthAuthenticated(
          await _signUp(fullName: fullName, email: email, password: password),
        ),
      );
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

  User? get currentUser => state is AuthAuthenticated
      ? (state as AuthAuthenticated).user
      : _repository.currentUser;
}
