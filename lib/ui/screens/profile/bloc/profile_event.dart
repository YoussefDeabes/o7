part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetProfileInfoEvent extends ProfileEvent {
  const GetProfileInfoEvent();
}

class UpdateProfilePersonalInfoEvent extends ProfileEvent {
  final UpdateProfileSendModel updateProfileSendModel;
  const UpdateProfilePersonalInfoEvent({required this.updateProfileSendModel});
}

class UpdateProfileContactInfoEvent extends ProfileEvent {
  final UpdateProfileSendModel updateProfileSendModel;
  const UpdateProfileContactInfoEvent({required this.updateProfileSendModel});
}

class UpdateProfileEmergenceContactInfoEvent extends ProfileEvent {
  final UpdateProfileSendModel updateProfileSendModel;
  const UpdateProfileEmergenceContactInfoEvent(
      {required this.updateProfileSendModel});
}
