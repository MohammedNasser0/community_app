import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';
import '../../services/device_info_service.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded({required this.user, required this.deviceInfo});
  final User user;
  final DeviceInfoData deviceInfo;
  @override
  List<Object?> get props => [user, deviceInfo.model, deviceInfo.osVersion];
}

class ProfileError extends ProfileState {
  const ProfileError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
