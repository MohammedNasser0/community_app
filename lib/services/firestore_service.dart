import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._internal();

  static final FirestoreService _instance = FirestoreService._internal();

  factory FirestoreService() {
    return _instance;
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get users =>
      firestore.collection('users');

  CollectionReference<Map<String, dynamic>> get posts =>
      firestore.collection('posts');
}
