import 'package:equatable/equatable.dart';

import '../../domain/entities/post.dart';

abstract class PostState extends Equatable {
  const PostState();
  @override
  List<Object?> get props => [];
}

class PostInitial extends PostState {
  const PostInitial();
}

class PostLoading extends PostState {
  const PostLoading();
}

class PostLoaded extends PostState {
  const PostLoaded(this.posts);
  final List<Post> posts;
  @override
  List<Object?> get props => [posts];
}

class PostError extends PostState {
  const PostError(this.message, {this.cachedPosts = const []});
  final String message;
  final List<Post> cachedPosts;
  @override
  List<Object?> get props => [message, cachedPosts];
}
