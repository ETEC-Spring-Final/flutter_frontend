part of 'profile_bloc.dart';

sealed class ProfileState {
  const ProfileState();
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileLoaded extends ProfileState {
  final UserProfile profile;

  const ProfileLoaded(this.profile);
}

final class ProfileUpdating extends ProfileState {
  final UserProfile profile;

  const ProfileUpdating(this.profile);
}

final class ProfileError extends ProfileState {
  final Failure failure;

  /// Last successfully loaded profile, kept on screen when a later
  /// refresh/update fails so the header does not vanish.
  final UserProfile? cached;

  const ProfileError(this.failure, {this.cached});
}