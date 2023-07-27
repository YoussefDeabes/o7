part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class LoadingProfileState extends ProfileState {
  const LoadingProfileState();
}

class LoadedProfileState extends ProfileState {
  final MyProfileWrapper myProfileWrapper;
  const LoadedProfileState({required this.myProfileWrapper});
}

class ExceptionProfileState extends ProfileState {
  final String exception;

  const ExceptionProfileState(this.exception);
}

class LoadingToUpdatePersonalInfoState extends ProfileState {
  const LoadingToUpdatePersonalInfoState();
}

class LoadingToUpdateContactInfoState extends ProfileState {
  const LoadingToUpdateContactInfoState();
}

class LoadingToUpdateEmergencyContactInfoState extends ProfileState {
  const LoadingToUpdateEmergencyContactInfoState();
}

class SuccessUpdateProfilePersonalInfoState extends ProfileState {
  final UpdateProfileSuccessModel updateProfileSuccessModel;

  const SuccessUpdateProfilePersonalInfoState(this.updateProfileSuccessModel);
}

class SuccessUpdateProfileContactInfoState extends ProfileState {
  final UpdateProfileSuccessModel updateProfileSuccessModel;

  const SuccessUpdateProfileContactInfoState(this.updateProfileSuccessModel);
}

class SuccessUpdateProfileEmergencyContactInfoState extends ProfileState {
  final UpdateProfileSuccessModel updateProfileSuccessModel;

  const SuccessUpdateProfileEmergencyContactInfoState(
      this.updateProfileSuccessModel);
}

class ExceptionUpdateProfilePersonalInfoState extends ProfileState {
  final String exception;

  const ExceptionUpdateProfilePersonalInfoState(this.exception);
}

class ExceptionUpdateProfileContactInfoState extends ProfileState {
  final String exception;

  const ExceptionUpdateProfileContactInfoState(this.exception);
}

class ExceptionUpdateProfileEmergencyContactInfoState extends ProfileState {
  final String exception;

  const ExceptionUpdateProfileEmergencyContactInfoState(this.exception);
}
