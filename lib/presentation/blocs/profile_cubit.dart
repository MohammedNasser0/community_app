import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/update_profile_image.dart';
import '../../services/device_info_service.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required this._repository,
    required this._deviceInfoService,
    required this._updateProfileImage,
  }) : super(const ProfileInitial());

  final AuthRepository _repository;
  final DeviceInfoService _deviceInfoService;
  final UpdateProfileImage _updateProfileImage;
  User? _user;

  Future<void> load(String userId) async {
    emit(const ProfileLoading());
    try {
      _user = await _repository.getUser(userId) ?? _repository.currentUser;
      if (_user == null) throw StateError('Profile not found.');
      emit(
        ProfileLoaded(
          user: _user!,
          deviceInfo: await _deviceInfoService.getInfo(),
        ),
      );
    } catch (error) {
      emit(ProfileError(FailureMessage.fromException(error)));
    }
  }

  Future<void> updateImage(String userId, Uint8List bytes) async {
    try {
      final updated = await _updateProfileImage(userId: userId, bytes: bytes);
      if (updated == null) throw StateError('Unable to update profile image.');
      _user = updated;
      final info = await _deviceInfoService.getInfo();
      emit(ProfileLoaded(user: updated, deviceInfo: info));
    } catch (error) {
      emit(ProfileError(FailureMessage.fromException(error)));
    }
  }
}
