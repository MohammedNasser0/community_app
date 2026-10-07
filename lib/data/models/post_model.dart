import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/post.dart';

class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.userId,
    required super.userName,
    super.userImageUrl,
    required super.content,
    required super.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json, {required String id}) {
    final timestamp = json['createdAt'];

    return PostModel(
      id: id,
      userId: json['userId'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      userImageUrl: json['userImageUrl'] as String?,
      content: json['content'] as String? ?? '',
      createdAt: timestamp is Timestamp
          ? timestamp.toDate()
          : DateTime.tryParse(timestamp?.toString() ?? '') ?? DateTime.now(),
    );
  }

  factory PostModel.fromEntity(Post post) {
    return PostModel(
      id: post.id,
      userId: post.userId,
      userName: post.userName,
      userImageUrl: post.userImageUrl,
      content: post.content,
      createdAt: post.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'userImageUrl': userImageUrl,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
