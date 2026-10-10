import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final topics = [
      'Design',
      'Flutter',
      'Photography',
      'Travel',
      'Technology',
      'Community',
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Explore',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
        children: [
          TextField(
            readOnly: true,
            onTap: () {},
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search community',
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Discover topics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppTheme.text,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: topics
                .map(
                  (topic) => Chip(
                    label: Text(topic),
                    avatar: const Icon(Icons.tag, size: 16),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 30),
          const Text(
            'Community highlights',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppTheme.text,
            ),
          ),
          const SizedBox(height: 14),
          ...[
            'Build in public',
            'Mobile architecture',
            'Creative photography',
          ].map(
            (title) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE7E7FF),
                  child: Icon(Icons.auto_awesome, color: AppTheme.primary),
                ),
                title: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: const Text(
                  'Join the conversation and meet new members.',
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
