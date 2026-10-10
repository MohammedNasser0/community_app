import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart' as firebase;

import '../../domain/entities/user.dart';
import '../../domain/entities/user_builder.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../services/auth_service.dart';
import '../datasources/user_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this._authService,
    required this._userDataSource,
  });

  final AuthService _authService;
  final UserRemoteDataSource _userDataSource;

  @override
  User? get currentUser {
    final user = _authService.currentUser;
    if (user == null) return null;
    return UserBuilder()
        .setId(user.uid)
        .setFullName(user.displayName ?? 'ConnectMe Member')
        .setEmail(user.email ?? '')
        .build();
  }

  Future<User> _buildUser(
    firebase.User firebaseUser, {
    String? fallbackEmail,
  }) async {
    final stored = await _userDataSource.getUser(firebaseUser.uid);
    if (stored != null) return stored;
    return UserBuilder()
        .setId(firebaseUser.uid)
        .setFullName(firebaseUser.displayName ?? 'ConnectMe Member')
        .setEmail(firebaseUser.email ?? fallbackEmail ?? '')
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
      throw StateError('Unable to retrieve user information.');
    }
    return _buildUser(firebaseUser, fallbackEmail: email);
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
    if (firebaseUser == null) throw StateError('Unable to create user.');

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
  Future<void> logout() => _authService.signOut();

  @override
  Future<User?> getUser(String userId) => _userDataSource.getUser(userId);

  @override
  Future<User?> updateProfileImage({
    required String userId,
    required List<int> bytes,
  }) async {
    final model = await _userDataSource.updateProfileImage(
      userId: userId,
      bytes: Uint8List.fromList(bytes),
    );
    return model;
  }
}
