import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/local_post_datasource.dart';
import '../datasources/post_remote_datasource.dart';
import '../models/post_model.dart';

enum PostRepositoryMode { remote, local }

class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl({
    required this._remoteDataSource,
    required this._localDataSource,
    required this._mode,
  });

  final PostRemoteDataSource _remoteDataSource;
  final LocalPostDataSource _localDataSource;
  final PostRepositoryMode _mode;

  @override
  Stream<List<Post>> getPosts() async* {
    if (_mode == PostRepositoryMode.local) {
      yield await _localDataSource.getPosts();
      return;
    }

    yield* _remoteDataSource.watchPosts().asyncMap((posts) async {
      await _localDataSource.savePosts(posts);
      return posts;
    });
  }

  @override
  Future<List<Post>> getCachedPosts() => _localDataSource.getPosts();

  @override
  Future<void> createPost(Post post) async {
    if (_mode == PostRepositoryMode.local) {
      throw StateError('Local post repository is read-only.');
    }
    await _remoteDataSource.createPost(PostModel.fromEntity(post));
  }
}
