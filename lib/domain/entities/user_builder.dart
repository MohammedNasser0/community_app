import 'user.dart';

class UserBuilder {
  String? _id;
  String? _fullName;
  String? _email;
  String? _profileImageBase64;

  UserBuilder setId(String value) {
    _id = value;
    return this;
  }

  UserBuilder setFullName(String value) {
    _fullName = value;
    return this;
  }

  UserBuilder setEmail(String value) {
    _email = value;
    return this;
  }

  UserBuilder setProfileImageBase64(String? value) {
    _profileImageBase64 = value;
    return this;
  }

  User build() {
    if (_id == null || _id!.isEmpty) throw StateError('User id is required.');
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
      profileImageBase64: _profileImageBase64,
    );
  }
}
