import 'dart:convert';
import 'dart:typed_data';

import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    super.profileImageBase64,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, {required String id}) {
    return UserModel(
      id: id,
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      profileImageBase64: json['profileImageBase64'] as String?,
    );
  }

  factory UserModel.fromEntity(User user) => UserModel(
    id: user.id,
    fullName: user.fullName,
    email: user.email,
    profileImageBase64: user.profileImageBase64,
  );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{'fullName': fullName, 'email': email};
    if (profileImageBase64 != null) {
      data['profileImageBase64'] = profileImageBase64;
    }
    return data;
  }

  Uint8List? get profileBytes {
    if (profileImageBase64 == null || profileImageBase64!.isEmpty) return null;
    try {
      return base64Decode(profileImageBase64!);
    } catch (_) {
      return null;
    }
  }
}
