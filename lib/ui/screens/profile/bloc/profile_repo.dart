import 'package:o7therapy/api/auth_api_manager.dart';
import 'package:o7therapy/api/models/profile/update_profile_send_model.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/ui/screens/profile/bloc/profile_bloc.dart';
import 'package:o7therapy/util/secure_storage_helper/secure_storage.dart';

import '../../../../api/errors/network_exceptions.dart';
import '../../../../api/models/auth/my_profile/my_profile_wrapper.dart';
import '../../../../api/models/profile/update_profile_success_model.dart';
import '../../../../api/profile_api_manager.dart';

abstract class BaseProfileRepo {
  const BaseProfileRepo();

  /// get Profile info
  Future<ProfileState> getProfileInfo();
}

class ProfileRepo extends BaseProfileRepo {
  const ProfileRepo();

  @override
  Future<ProfileState> getProfileInfo() async {
    late ProfileState state;
    try {
      await ProfileApiManager.getMyProfileApi(
        success: (MyProfileWrapper myProfileWrapper) async {
          state = LoadedProfileState(myProfileWrapper: myProfileWrapper);
          await PrefManager.setName(myProfileWrapper.data?.name ?? "");
          await SecureStorage.setName(myProfileWrapper.data?.name ?? "");
        },
        fail: (NetworkExceptions details) {
          state = ExceptionProfileState(
              details.errorMsg ?? "Oops... Something went wrong!");
        },
      );
    } catch (error) {
      state = const ExceptionProfileState("Oops... Something went wrong!");
    }
    return state;
  }

  Future<ProfileState> updateProfilePersonalInfo(
      {required UpdateProfileSendModel updateProfileSendModel}) async {
    late ProfileState state;
    try {
      await ProfileApiManager.updateProfilePersonalInfo(
        updateProfileModel: updateProfileSendModel,
        success: (UpdateProfileSuccessModel updateProfileSuccessModel) {
          state =
              SuccessUpdateProfilePersonalInfoState(updateProfileSuccessModel);
        },
        fail: (NetworkExceptions details) {
          state = ExceptionUpdateProfilePersonalInfoState(
              details.errorMsg ?? "Oops... Something went wrong!");
        },
      );
    } catch (error) {
      state = const ExceptionUpdateProfilePersonalInfoState(
          "Oops... Something went wrong!");
    }
    return state;
  }

  Future<ProfileState> updateProfileContactInfo(
      {required UpdateProfileSendModel updateProfileSendModel}) async {
    late ProfileState state;
    try {
      await ProfileApiManager.updateProfileContactInfo(
        updateProfileModel: updateProfileSendModel,
        success: (UpdateProfileSuccessModel updateProfileSuccessModel) {
          state =
              SuccessUpdateProfileContactInfoState(updateProfileSuccessModel);
        },
        fail: (NetworkExceptions details) {
          state = ExceptionUpdateProfileContactInfoState(
              details.errorMsg ?? "Oops... Something went wrong!");
        },
      );
    } catch (error) {
      state = const ExceptionUpdateProfileContactInfoState(
          "Oops... Something went wrong!");
    }
    return state;
  }

  Future<ProfileState> updateProfileEmergencyContactInfo(
      {required UpdateProfileSendModel updateProfileSendModel}) async {
    late ProfileState state;
    try {
      await ProfileApiManager.updateProfileEmergencyContactInfo(
        updateProfileModel: updateProfileSendModel,
        success: (UpdateProfileSuccessModel updateProfileSuccessModel) {
          state = SuccessUpdateProfileEmergencyContactInfoState(
              updateProfileSuccessModel);
        },
        fail: (NetworkExceptions details) {
          state = ExceptionUpdateProfileEmergencyContactInfoState(
              details.errorMsg ?? "Oops... Something went wrong!");
        },
      );
    } catch (error) {
      state = const ExceptionUpdateProfileEmergencyContactInfoState(
          "Oops... Something went wrong!");
    }
    return state;
  }
}
