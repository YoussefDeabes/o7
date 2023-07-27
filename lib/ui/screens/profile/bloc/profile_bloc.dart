import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:o7therapy/api/models/auth/my_profile/my_profile_wrapper.dart';
import 'package:o7therapy/ui/screens/profile/bloc/profile_repo.dart';

import '../../../../api/models/profile/update_profile_send_model.dart';
import '../../../../api/models/profile/update_profile_success_model.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepo profileRepo;
  ProfileBloc({required this.profileRepo}) : super(ProfileInitial()) {
    on<GetProfileInfoEvent>(_onGetProfileInfo);
    on<UpdateProfilePersonalInfoEvent>(_onUpdateProfilePersonalInfo);
    on<UpdateProfileContactInfoEvent>(_onUpdateProfileContactInfo);
    on<UpdateProfileEmergenceContactInfoEvent>(
        _onUpdateProfileEmergencyContactInfo);
  }
  static ProfileBloc bloc(BuildContext context) => context.read<ProfileBloc>();

  _onGetProfileInfo(event, emit) async {
    emit(const LoadingProfileState());
    emit(await profileRepo.getProfileInfo());
  }

  _onUpdateProfilePersonalInfo(
      UpdateProfilePersonalInfoEvent event, emit) async {
    emit(const LoadingToUpdatePersonalInfoState());
    emit(await profileRepo.updateProfilePersonalInfo(
        updateProfileSendModel: event.updateProfileSendModel));
  }

  _onUpdateProfileContactInfo(UpdateProfileContactInfoEvent event, emit) async {
    emit(const LoadingToUpdateContactInfoState());
    emit(await profileRepo.updateProfileContactInfo(
        updateProfileSendModel: event.updateProfileSendModel));
  }

  _onUpdateProfileEmergencyContactInfo(
      UpdateProfileEmergenceContactInfoEvent event, emit) async {
    emit(const LoadingToUpdateEmergencyContactInfoState());
    emit(await profileRepo.updateProfileEmergencyContactInfo(
        updateProfileSendModel: event.updateProfileSendModel));
  }
}
