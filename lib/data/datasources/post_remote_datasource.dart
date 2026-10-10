import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_constants.dart';
import '../../services/firestore_service.dart';
import '../models/post_model.dart';

class PostRemoteDataSource {
  PostRemoteDataSource({required FirestoreService firestoreService})
    : _firestore = firestoreService.firestore;

  final FirebaseFirestore _firestore;

  Stream<List<PostModel>> watchPosts() {
    return _firestore
        .collection(AppConstants.postsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PostModel.fromJson(doc.data(), id: doc.id))
              .toList(),
        );
  }

  Future<void> createPost(PostModel post) async {
    final reference = post.id.isEmpty
        ? _firestore.collection(AppConstants.postsCollection).doc()
        : _firestore.collection(AppConstants.postsCollection).doc(post.id);

    await reference.set(post.toJson());
  }
}
