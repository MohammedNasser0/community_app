import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/user.dart';
import '../blocs/profile_cubit.dart';
import '../blocs/profile_state.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/brand_header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.user});
  final User user;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<ProfileCubit>().load(widget.user.id),
    );
  }

  Future<void> pickImage() async {
    try {
      final file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 720,
        maxHeight: 720,
        imageQuality: 65,
      );
      if (file == null || !mounted) return;
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      if (bytes.lengthInBytes > 650 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please choose a smaller image.')),
        );
        return;
      }
      await context.read<ProfileCubit>().updateImage(widget.user.id, bytes);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Could not select photo. Please try again."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is! ProfileLoaded) {
            return const Center(child: Text('Unable to load profile.'));
          }
          final user = state.user;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const BrandHeader(title: 'MY COMMUNITY', compact: true),
              const SizedBox(height: 20),
              Center(
                child: Stack(
                  children: [
                    ProfileAvatar(
                      base64Image: user.profileImageBase64,
                      radius: 56,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: InkWell(
                        onTap: pickImage,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: Text(
                  user.fullName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.text,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Center(
                child: Text(
                  user.email,
                  style: const TextStyle(color: AppTheme.muted),
                ),
              ),
              const SizedBox(height: 28),
              _InfoCard(
                icon: Icons.smartphone_outlined,
                title: 'Device Model',
                value: state.deviceInfo.model,
              ),
              const SizedBox(height: 12),
              _InfoCard(
                icon: Icons.android_outlined,
                title: 'Operating System',
                value: state.deviceInfo.osVersion,
              ),
              const SizedBox(height: 12),
              _InfoCard(
                icon: Icons.security_outlined,
                title: 'Profile protection',
                value: 'Biometric authentication enabled',
              ),
              const SizedBox(height: 24),
              const Text(
                'Add a photo so your community can recognize you.',
                style: TextStyle(color: AppTheme.muted, height: 1.4),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });
  final IconData icon;
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFEDEEFF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppTheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: AppTheme.muted),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.text,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
