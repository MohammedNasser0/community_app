import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.fullName,
    required this.email,
    this.profileImageBase64,
  });

  final String id;
  final String fullName;
  final String email;
  final String? profileImageBase64;

  @override
  List<Object?> get props => [id, fullName, email, profileImageBase64];
}
