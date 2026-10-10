import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_constants.dart';
import '../../services/firestore_service.dart';
import '../../domain/entities/user.dart';
import '../models/user_model.dart';

class UserRemoteDataSource {
  UserRemoteDataSource({required FirestoreService firestoreService})
    : _firestore = firestoreService.firestore;

  final FirebaseFirestore _firestore;

  Future<void> createUser(User user) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.id)
        .set(UserModel.fromEntity(user).toJson());
  }

  Future<UserModel?> getUser(String userId) async {
    final snapshot = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .get();
    if (!snapshot.exists || snapshot.data() == null) return null;
    return UserModel.fromJson(snapshot.data()!, id: snapshot.id);
  }

  Future<UserModel?> updateProfileImage({
    required String userId,
    required Uint8List bytes,
  }) async {
    if (bytes.lengthInBytes > AppConstants.maxProfileImageBytes) {
      throw StateError(
        'Profile image is too large. Please choose another image.',
      );
    }

    final base64Image = base64Encode(bytes);
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .update({'profileImageBase64': base64Image});

    return getUser(userId);
  }
}
