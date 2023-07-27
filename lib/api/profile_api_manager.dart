import 'package:o7therapy/api/models/profile/update_profile_send_model.dart';

import 'api_keys.dart';
import 'base/base_api_manager.dart';
import 'errors/network_exceptions.dart';
import 'models/auth/my_profile/my_profile_wrapper.dart';
import 'models/profile/update_profile_success_model.dart';

class ProfileApiManager {
  static Future<void> getMyProfileApi({
    required void Function(MyProfileWrapper) success,
    required void Function(NetworkExceptions) fail,
  }) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio.get(ApiKeys.myProfileUrl);
      MyProfileWrapper wrapper = MyProfileWrapper.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  static Future<void> updateProfilePersonalInfo(
      {required UpdateProfileSendModel updateProfileModel,
      required void Function(UpdateProfileSuccessModel) success,
      required void Function(NetworkExceptions) fail}) async {
    await BaseApi.updateHeader();
    await BaseApi.dio
        .put(ApiKeys.updateProfileUrl,
            data: updateProfileModel.updatePersonalInfoToMap())
        .then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      UpdateProfileSuccessModel wrapper =
          UpdateProfileSuccessModel.fromJson(extractedData);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    }).catchError((onError) {
      fail(NetworkExceptions.getDioException(onError));
    });
  }

  static Future<void> updateProfileContactInfo(
      {required UpdateProfileSendModel updateProfileModel,
      required void Function(UpdateProfileSuccessModel) success,
      required void Function(NetworkExceptions) fail}) async {
    await BaseApi.updateHeader();
    await BaseApi.dio
        .put(ApiKeys.updateProfileUrl,
            data: updateProfileModel.updateContactInfoToMap())
        .then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      UpdateProfileSuccessModel wrapper =
          UpdateProfileSuccessModel.fromJson(extractedData);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    }).catchError((onError) {
      fail(NetworkExceptions.getDioException(onError));
    });
  }

  static Future<void> updateProfileEmergencyContactInfo(
      {required UpdateProfileSendModel updateProfileModel,
      required void Function(UpdateProfileSuccessModel) success,
      required void Function(NetworkExceptions) fail}) async {
    await BaseApi.updateHeader();
    await BaseApi.dio
        .put(ApiKeys.updateProfileUrl,
            data: updateProfileModel.updateEmergencyContactInfoToMap())
        .then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      UpdateProfileSuccessModel wrapper =
          UpdateProfileSuccessModel.fromJson(extractedData);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    }).catchError((onError) {
      fail(NetworkExceptions.getDioException(onError));
    });
  }
}
