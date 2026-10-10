import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/post_model.dart';

class LocalPostDataSource {
  LocalPostDataSource({required this._preferences});

  static const _key = 'connectme_cached_posts';
  final SharedPreferences _preferences;

  Future<void> savePosts(List<PostModel> posts) async {
    final data = posts.map((post) => post.toJsonForCache()).toList();
    await _preferences.setString(_key, jsonEncode(data));
  }

  Future<List<PostModel>> getPosts() async {
    final raw = _preferences.getString(_key);
    if (raw == null || raw.isEmpty) return [];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];

      return decoded
          .whereType<Map>()
          .map(
            (item) => PostModel.fromCacheJson(Map<String, dynamic>.from(item)),
          )
          .toList();
    } catch (_) {
      await _preferences.remove(_key);
      return [];
    }
  }
}
