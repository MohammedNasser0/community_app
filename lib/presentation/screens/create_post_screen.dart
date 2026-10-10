import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/post.dart';
import '../blocs/post_cubit.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({
    super.key,
    required this.userId,
    required this.userName,
    this.userImageBase64,
  });
  final String userId;
  final String userName;
  final String? userImageBase64;
  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  bool saving = false;
  final controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (saving) return;
    final content = controller.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Write something before publishing.')),
      );
      return;
    }
    setState(() => saving = true);
    final success = await context.read<PostCubit>().createPost(
      post: Post(
        id: '',
        userId: widget.userId,
        userName: widget.userName,
        userImageUrl: widget.userImageBase64,
        content: content,
        createdAt: DateTime.now(),
      ),
    );
    if (!mounted) return;
    setState(() => saving = false);
    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not publish. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Post',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          TextButton(
            onPressed: saving ? null : save,
            child: Text(saving ? 'Publishing…' : 'Publish'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Share with the community',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.text,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              maxLines: 9,
              maxLength: 500,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'What would you like to share?',
              ),
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(Icons.public, size: 18, color: AppTheme.muted),
                SizedBox(width: 8),
                Text(
                  'Visible to ConnectMe members',
                  style: TextStyle(color: AppTheme.muted),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
