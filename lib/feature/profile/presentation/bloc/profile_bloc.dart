import 'package:bloc/bloc.dart';
import 'package:vehicle_rental_system/core/errors/failure.dart';
import 'package:vehicle_rental_system/feature/profile/domain/entity/user_profile.dart';
import 'package:vehicle_rental_system/feature/profile/domain/repository/user_profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserProfileRepository _repository;

  UserProfile? _profile;

  ProfileBloc(this._repository) : super(const ProfileInitial()) {
    on<LoadProfileEvent>(_onLoad);
    on<UpdateProfileEvent>(_onUpdate);
    on<UpdateProfilePictureEvent>(_onUpdatePicture);

    add(const LoadProfileEvent());
  }

  Future<void> _onLoad(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is! ProfileLoaded) {
      emit(const ProfileLoading());
    }

    final result = await _repository.getMyProfile();

    result.fold(
      (failure) => emit(ProfileError(failure, cached: _profile)),
      (profile) {
        _profile = profile;
        emit(ProfileLoaded(profile));
      },
    );
  }

  Future<void> _onUpdate(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final current = _profile;
    if (current != null) {
      emit(ProfileUpdating(current));
    }

    final result = await _repository.updateMyProfile(
      firstName: event.firstName,
      lastName: event.lastName,
      phone: event.phone,
      profilePicture: event.profilePicture,
    );

    result.fold(
      (failure) => emit(ProfileError(failure, cached: current ?? _profile)),
      (profile) {
        _profile = profile;
        emit(ProfileLoaded(profile));
      },
    );
  }

  Future<void> _onUpdatePicture(
    UpdateProfilePictureEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final current = _profile;
    if (current == null) {
      emit(const ProfileError(ServiceFailure('Profile not loaded yet.')));
      return;
    }

    final upload = await _repository.uploadProfileImage(event.filePath);

    upload.fold(
      (failure) => emit(ProfileError(failure, cached: current)),
      (url) {
        add(
          UpdateProfileEvent(
            firstName: current.firstName,
            lastName: current.lastName,
            phone: current.phone ?? '',
            profilePicture: url,
          ),
        );
      },
    );
  }
}