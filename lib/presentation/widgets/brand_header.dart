import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Diagonal ribbons echo the supplied social UI kit without external assets.
class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key, this.title = 'WELCOME', this.compact = false});
  final String title;
  final bool compact;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(42)),
      child: Container(
        height: compact ? 150 : 230,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFF173F6C), Color(0xFF39215D), Color(0xFF181526)],
          ),
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            for (var i = 0; i < 6; i++)
              Positioned(
                left: i * 85.0 - 100,
                top: -85,
                child: Transform.rotate(
                  angle: .72,
                  child: Container(
                    width: 52,
                    height: 430,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.secondary.withValues(alpha: .45),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'connectme.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      letterSpacing: 5,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'SHARE · INSPIRE · CONNECT',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 9,
                      letterSpacing: 2,
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
}
