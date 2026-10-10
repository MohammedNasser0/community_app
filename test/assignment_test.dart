import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectme_app/core/utils/validators.dart';
import 'package:connectme_app/data/datasources/local_post_datasource.dart';
import 'package:connectme_app/data/models/post_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Signup rejects invalid fields and mismatched passwords', () {
    expect(Validators.name('omar'), isNotNull);
    expect(Validators.name('Omar Khalil'), isNull);
    expect(Validators.email('omar'), isNotNull);
    expect(Validators.password('12345'), isNotNull);
    expect(Validators.confirmPassword('123456', '654321'), isNotNull);
  });
  test('Corrupt local cache does not prevent feed loading', () async {
    SharedPreferences.setMockInitialValues({
      'connectme_cached_posts': '{broken',
    });
    final source = LocalPostDataSource(
      preferences: await SharedPreferences.getInstance(),
    );
    expect(await source.getPosts(), isEmpty);
  });
  test('Post cache preserves author, content and timestamp', () async {
    SharedPreferences.setMockInitialValues({});
    final source = LocalPostDataSource(
      preferences: await SharedPreferences.getInstance(),
    );
    final post = PostModel(
      id: 'post1',
      userId: 'member1',
      userName: 'Omar',
      content: 'Hello community',
      createdAt: DateTime.utc(2026, 10, 10),
    );
    await source.savePosts([post]);
    expect(await source.getPosts(), [post]);
  });
}
