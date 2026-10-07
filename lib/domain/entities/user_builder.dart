import 'user.dart';

class UserBuilder {
  String? _id;
  String? _fullName;
  String? _email;
  String? _profileImageUrl;

  UserBuilder setId(String id) {
    _id = id;
    return this;
  }

  UserBuilder setFullName(String fullName) {
    _fullName = fullName;
    return this;
  }

  UserBuilder setEmail(String email) {
    _email = email;
    return this;
  }

  UserBuilder setProfileImageUrl(String? profileImageUrl) {
    _profileImageUrl = profileImageUrl;
    return this;
  }

  User build() {
    if (_id == null || _id!.isEmpty) {
      throw StateError('User id is required.');
    }

    if (_fullName == null || _fullName!.isEmpty) {
      throw StateError('User full name is required.');
    }

    if (_email == null || _email!.isEmpty) {
      throw StateError('User email is required.');
    }

    return User(
      id: _id!,
      fullName: _fullName!,
      email: _email!,
      profileImageUrl: _profileImageUrl,
    );
  }
}
