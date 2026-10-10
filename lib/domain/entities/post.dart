import 'package:equatable/equatable.dart';

class Post extends Equatable {
  const Post({
    required this.id,
    required this.userId,
    required this.userName,
    this.userImageUrl,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String userName;
  final String? userImageUrl;
  final String content;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
    id,
    userId,
    userName,
    userImageUrl,
    content,
    createdAt,
  ];
}
