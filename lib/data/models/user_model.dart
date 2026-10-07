import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    super.profileImageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, {required String id}) {
    return UserModel(
      id: id,
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      fullName: user.fullName,
      email: user.email,
      profileImageUrl: user.profileImageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{'fullName': fullName, 'email': email};

    if (profileImageUrl != null) {
      data['profileImageUrl'] = profileImageUrl;
    }

    return data;
  }
}
