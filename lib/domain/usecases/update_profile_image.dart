import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class UpdateProfileImage {
  UpdateProfileImage({required this._repository});
  final AuthRepository _repository;

  Future<User?> call({required String userId, required List<int> bytes}) {
    return _repository.updateProfileImage(userId: userId, bytes: bytes);
  }
}
