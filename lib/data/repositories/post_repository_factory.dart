import '../../domain/repositories/post_repository.dart';
import '../datasources/local_post_datasource.dart';
import '../datasources/post_remote_datasource.dart';
import 'post_repository_impl.dart';

enum PostDataSourceType { remote, local }

class PostRepositoryFactory {
  PostRepositoryFactory._();

  static PostRepository create({
    required PostDataSourceType type,
    required PostRemoteDataSource remoteDataSource,
    required LocalPostDataSource localDataSource,
  }) {
    // Factory Pattern: switch between remote Firestore and local cache.
    return PostRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      mode: type == PostDataSourceType.remote
          ? PostRepositoryMode.remote
          : PostRepositoryMode.local,
    );
  }
}
