import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_theme.dart';
import '../widgets/brand_header.dart';
import '../../domain/entities/user.dart';
import '../../services/biometric_service.dart';
import '../../injection.dart';
import '../blocs/auth_cubit.dart';
import '../blocs/post_cubit.dart';
import '../blocs/post_state.dart';
import '../blocs/profile_cubit.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/post_card.dart';
import '../widgets/profile_avatar.dart';
import 'create_post_screen.dart';
import 'explore_screen.dart';
import 'map_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthCubit>();
    final user = auth.currentUser;
    if (user == null) return const SizedBox.shrink();
    final pages = [
      _HomeFeed(user: user),
      const ExploreScreen(),
      const MapScreen(),
    ];
    return BlocProvider(
      create: (_) => getIt<PostCubit>()..start(),
      child: Scaffold(
        body: IndexedStack(index: index, children: pages),
        bottomNavigationBar: Builder(
          builder: (feedContext) => AppBottomNav(
            onCreate: () => Navigator.push(
              feedContext,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: feedContext.read<PostCubit>(),
                  child: CreatePostScreen(
                    userId: user.id,
                    userName: user.fullName,
                    userImageBase64: user.profileImageBase64,
                  ),
                ),
              ),
            ),
            index: index,
            onChanged: (value) => setState(() => index = value),
          ),
        ),
      ),
    );
  }
}

class _HomeFeed extends StatelessWidget {
  const _HomeFeed({required this.user});
  final User user;
  Future<void> openProfile(BuildContext context) async {
    final authenticated = await getIt<BiometricService>().authenticate();
    if (!context.mounted) return;
    if (!authenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Biometric authentication failed or is unavailable.'),
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => getIt<ProfileCubit>(),
          child: ProfileScreen(user: user),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ConnectMe',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            onPressed: () => openProfile(context),
            icon: ProfileAvatar(
              base64Image: user.profileImageBase64,
              radius: 17,
            ),
          ),
          IconButton(
            onPressed: () => context.read<AuthCubit>().logout(),
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<PostCubit>(),
              child: CreatePostScreen(
                userId: user.id,
                userName: user.fullName,
                userImageBase64: user.profileImageBase64,
              ),
            ),
          ),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Post'),
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<PostCubit>().start(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
          children: [
            const Text(
              'Good to see you',
              style: TextStyle(color: AppTheme.muted, fontSize: 13),
            ),
            const SizedBox(height: 2),
            Text(
              user.fullName.split(' ').first,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: AppTheme.text,
              ),
            ),
            const SizedBox(height: 20),
            const BrandHeader(title: 'YOUR COMMUNITY', compact: true),
            const SizedBox(height: 22),
            BlocBuilder<PostCubit, PostState>(
              builder: (context, state) {
                if (state is PostLoading || state is PostInitial) {
                  return const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (state is PostError && state.cachedPosts.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.cloud_off,
                            size: 42,
                            color: AppTheme.muted,
                          ),
                          const SizedBox(height: 10),
                          Text(state.message, textAlign: TextAlign.center),
                          const SizedBox(height: 12),
                          FilledButton(
                            onPressed: () => context.read<PostCubit>().start(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                final posts = state is PostLoaded
                    ? state.posts
                    : (state as PostError).cachedPosts;
                if (posts.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(28),
                      child: Center(
                        child: Text(
                          'No posts yet. Be the first to share something!',
                        ),
                      ),
                    ),
                  );
                }
                return Column(
                  children: posts
                      .map(
                        (post) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: PostCard(post: post),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
