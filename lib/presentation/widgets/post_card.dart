import 'package:flutter/material.dart';

import '../../domain/entities/post.dart';
import 'profile_avatar.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});
  final Post post;

  String _timeAgo() {
    final difference = DateTime.now().difference(post.createdAt);
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes}m ago';
    if (difference.inDays < 1) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ProfileAvatar(base64Image: post.userImageUrl, radius: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.userName,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _timeAgo(),
                        style: const TextStyle(
                          color: Color(0xFF8A8F9C),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.more_horiz, color: Color(0xFF8A8F9C)),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              post.content,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.favorite_border, size: 21),
                SizedBox(width: 6),
                Text('Like'),
                SizedBox(width: 22),
                Icon(Icons.chat_bubble_outline, size: 20),
                SizedBox(width: 6),
                Text('Comment'),
                Spacer(),
                Icon(Icons.share_outlined, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
