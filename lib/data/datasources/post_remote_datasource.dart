import '../../services/firestore_service.dart';
import '../models/post_model.dart';

abstract class PostRemoteDataSource {
  Stream<List<PostModel>> getPosts();

  Future<void> createPost(PostModel post);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final FirestoreService firestoreService;

  PostRemoteDataSourceImpl(this.firestoreService);

  @override
  Stream<List<PostModel>> getPosts() {
    return firestoreService.posts
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return PostModel.fromJson(doc.data(), id: doc.id);
          }).toList();
        });
  }

  @override
  Future<void> createPost(PostModel post) async {
    await firestoreService.posts.doc(post.id).set(post.toJson());
  }
}
