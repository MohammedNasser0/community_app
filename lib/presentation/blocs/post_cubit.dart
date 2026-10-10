import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../../domain/usecases/create_post.dart';
import '../../domain/usecases/get_posts.dart';
import 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit({
    required this._repository,
    required this._getPosts,
    required this._createPost,
  }) : super(const PostInitial());

  final PostRepository _repository;
  final GetPosts _getPosts;
  final CreatePost _createPost;
  StreamSubscription<List<Post>>? _subscription;

  Future<void> start() async {
    emit(const PostLoading());
    try {
      await _subscription?.cancel();
      final cached = await _repository.getCachedPosts();
      if (isClosed) return;
      if (cached.isNotEmpty) emit(PostLoaded(cached));
      _subscription = _getPosts().listen(
        (posts) {
          if (!isClosed) emit(PostLoaded(posts));
        },
        onError: (Object error) {
          if (!isClosed) {
            emit(
              PostError(
                FailureMessage.fromException(error),
                cachedPosts: cached,
              ),
            );
          }
        },
      );
    } catch (error) {
      if (!isClosed) emit(PostError(FailureMessage.fromException(error)));
    }
  }

  Future<bool> createPost({required Post post}) async {
    try {
      await _createPost(post);
      return true;
    } catch (error) {
      emit(PostError(FailureMessage.fromException(error)));
      return false;
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
