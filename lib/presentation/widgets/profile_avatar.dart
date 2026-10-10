import 'dart:convert';

import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, this.base64Image, this.radius = 28});
  final String? base64Image;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final hasImage = base64Image != null && base64Image!.isNotEmpty;
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFFE8E9FF),
      backgroundImage: hasImage
          ? MemoryImage(base64Decode(base64Image!))
          : null,
      child: hasImage
          ? null
          : Icon(Icons.person, size: radius, color: const Color(0xFF5B5CE2)),
    );
  }
}
