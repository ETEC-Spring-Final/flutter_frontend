part of 'profile_bloc.dart';

sealed class ProfileEvent {
  const ProfileEvent();
}

final class LoadProfileEvent extends ProfileEvent {
  const LoadProfileEvent();
}

final class UpdateProfileEvent extends ProfileEvent {
  final String firstName;
  final String lastName;
  final String phone;
  final String? profilePicture;

  const UpdateProfileEvent({
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.profilePicture,
  });
}

final class UpdateProfilePictureEvent extends ProfileEvent {
  final String filePath;

  const UpdateProfilePictureEvent(this.filePath);
}