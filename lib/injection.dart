import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/datasources/local_post_datasource.dart';
import 'data/datasources/post_remote_datasource.dart';
import 'data/datasources/user_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/post_repository_factory.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/post_repository.dart';
import 'presentation/blocs/auth_cubit.dart';
import 'presentation/blocs/post_cubit.dart';
import 'presentation/blocs/profile_cubit.dart';
import 'services/auth_service.dart';
import 'services/biometric_service.dart';
import 'services/device_info_service.dart';
import 'services/firestore_service.dart';

import 'domain/usecases/login.dart';
import 'domain/usecases/sign_up.dart';
import 'domain/usecases/get_posts.dart';
import 'domain/usecases/create_post.dart';
import 'domain/usecases/update_profile_image.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  final preferences = await SharedPreferences.getInstance();
  if (!getIt.isRegistered<SharedPreferences>()) {
    getIt.registerSingleton<SharedPreferences>(preferences);
  }

  if (!getIt.isRegistered<AuthService>()) {
    getIt.registerLazySingleton<AuthService>(() => AuthService());
  }
  if (!getIt.isRegistered<FirestoreService>()) {
    getIt.registerLazySingleton<FirestoreService>(() => FirestoreService());
  }
  if (!getIt.isRegistered<BiometricService>()) {
    getIt.registerLazySingleton<BiometricService>(() => BiometricService());
  }
  if (!getIt.isRegistered<DeviceInfoService>()) {
    getIt.registerLazySingleton<DeviceInfoService>(() => DeviceInfoService());
  }

  if (!getIt.isRegistered<UserRemoteDataSource>()) {
    getIt.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSource(firestoreService: getIt<FirestoreService>()),
    );
  }
  if (!getIt.isRegistered<PostRemoteDataSource>()) {
    getIt.registerLazySingleton<PostRemoteDataSource>(
      () => PostRemoteDataSource(firestoreService: getIt<FirestoreService>()),
    );
  }
  if (!getIt.isRegistered<LocalPostDataSource>()) {
    getIt.registerLazySingleton<LocalPostDataSource>(
      () => LocalPostDataSource(preferences: getIt<SharedPreferences>()),
    );
  }

  if (!getIt.isRegistered<AuthRepository>()) {
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        authService: getIt<AuthService>(),
        userDataSource: getIt<UserRemoteDataSource>(),
      ),
    );
  }

  if (!getIt.isRegistered<PostRepository>()) {
    getIt.registerLazySingleton<PostRepository>(
      () => PostRepositoryFactory.create(
        type: PostDataSourceType.remote,
        remoteDataSource: getIt<PostRemoteDataSource>(),
        localDataSource: getIt<LocalPostDataSource>(),
      ),
    );
  }

  getIt.registerLazySingleton<Login>(
    () => Login(repository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<SignUp>(
    () => SignUp(repository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<GetPosts>(
    () => GetPosts(repository: getIt<PostRepository>()),
  );
  getIt.registerLazySingleton<CreatePost>(
    () => CreatePost(repository: getIt<PostRepository>()),
  );
  getIt.registerLazySingleton<UpdateProfileImage>(
    () => UpdateProfileImage(repository: getIt<AuthRepository>()),
  );
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      repository: getIt<AuthRepository>(),
      login: getIt<Login>(),
      signUp: getIt<SignUp>(),
    ),
  );
  getIt.registerFactory<PostCubit>(
    () => PostCubit(
      repository: getIt<PostRepository>(),
      getPosts: getIt<GetPosts>(),
      createPost: getIt<CreatePost>(),
    ),
  );
  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(
      repository: getIt<AuthRepository>(),
      updateProfileImage: getIt<UpdateProfileImage>(),
      deviceInfoService: getIt<DeviceInfoService>(),
    ),
  );
}
