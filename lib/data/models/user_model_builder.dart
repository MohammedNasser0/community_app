import 'user_model.dart';

class UserModelBuilder {
  String? _id;
  String? _fullName;
  String? _email;
  String? _profileImageUrl;

  UserModelBuilder setId(String id) {
    _id = id;
    return this;
  }

  UserModelBuilder setFullName(String fullName) {
    _fullName = fullName;
    return this;
  }

  UserModelBuilder setEmail(String email) {
    _email = email;
    return this;
  }

  UserModelBuilder setProfileImageUrl(String url) {
    _profileImageUrl = url;
    return this;
  }

  UserModel build() {
    if (_id == null || _fullName == null || _email == null) {
      throw StateError('User ID, full name, and email are required.');
    }

    return UserModel(
      id: _id!,
      fullName: _fullName!,
      email: _email!,
      profileImageUrl: _profileImageUrl,
    );
  }
}
