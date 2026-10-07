import 'package:firebase_auth/firebase_auth.dart' as firebase;

import '../../domain/entities/user.dart';
import '../../domain/entities/user_builder.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../services/auth_service.dart';
import '../datasources/user_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthService authService,
    required UserRemoteDataSource userDataSource,
  }) : _authService = authService,
       _userDataSource = userDataSource;

  final AuthService _authService;
  final UserRemoteDataSource _userDataSource;

  @override
  User? get currentUser {
    final firebaseUser = _authService.currentUser;

    if (firebaseUser == null) {
      return null;
    }

    return UserBuilder()
        .setId(firebaseUser.uid)
        .setFullName(firebaseUser.displayName ?? '')
        .setEmail(firebaseUser.email ?? '')
        .build();
  }

  @override
  Future<User> login({required String email, required String password}) async {
    final credential = await _authService.signIn(
      email: email,
      password: password,
    );

    final firebaseUser = credential.user;

    if (firebaseUser == null) {
      throw Exception('Unable to retrieve user information.');
    }

    final storedUser = await _userDataSource.getUser(firebaseUser.uid);

    if (storedUser != null) {
      return storedUser;
    }

    return UserBuilder()
        .setId(firebaseUser.uid)
        .setFullName(firebaseUser.displayName ?? '')
        .setEmail(firebaseUser.email ?? email)
        .build();
  }

  @override
  Future<User> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final credential = await _authService.signUp(
      email: email,
      password: password,
    );

    final firebaseUser = credential.user;

    if (firebaseUser == null) {
      throw Exception('Unable to create user.');
    }

    await firebaseUser.updateDisplayName(fullName);

    final user = UserBuilder()
        .setId(firebaseUser.uid)
        .setFullName(fullName)
        .setEmail(email)
        .build();

    await _userDataSource.createUser(user);

    return user;
  }

  @override
  Future<void> logout() {
    return _authService.signOut();
  }
}
