import 'package:connectme_app/data/datasources/post_remote_datasource.dart';
import 'package:connectme_app/data/repositories/post_repository_impl.dart';
import 'package:get_it/get_it.dart';

import 'domain/repositories/auth_repository.dart';
import 'presentation/blocs/auth_cubit.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Services
  if (!getIt.isRegistered<AuthService>()) {
    getIt.registerLazySingleton<AuthService>(() => AuthService());
  }

  if (!getIt.isRegistered<FirestoreService>()) {
    getIt.registerLazySingleton<FirestoreService>(() => FirestoreService());
  }

  // Data sources
  if (!getIt.isRegistered<UserRemoteDataSource>()) {
    getIt.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSource(firestoreService: getIt<FirestoreService>()),
    );
  }

  // Repository
  if (!getIt.isRegistered<AuthRepository>()) {
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        authService: getIt<AuthService>(),
        userDataSource: getIt<UserRemoteDataSource>(),
      ),
    );
  }

  // Cubit
  if (!getIt.isRegistered<AuthCubit>()) {
    getIt.registerFactory<AuthCubit>(
      () => AuthCubit(repository: getIt<AuthRepository>()),
    );
  }
}
