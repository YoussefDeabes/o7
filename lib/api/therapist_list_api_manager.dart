import 'dart:developer';

import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/api/base/base_api_manager.dart';
import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/models/booking/therapist_list/therapist_list_wrapper.dart';
import 'package:o7therapy/api/models/booking/therapists_booked_before/therapists_booked_before_wrapper.dart';
import 'package:o7therapy/api/models/guest_therapist_list/GuestTherapistList.dart';
import 'package:o7therapy/api/models/min_max/min_max.dart';
import 'package:o7therapy/prefs/pref_manager.dart';

import 'models/booking/verify_user_is_corporate/verify_user_is_corporate_wrapper.dart';

class TherapistListApiManager {
  static Future<void> therapistListApi(
    void Function(TherapistListWrapper) success,
    void Function(NetworkExceptions) fail, {
    required String attributeName,
    int pageNumber = 1,
    int pageSize = 5,
    required String direction,
    required Map<String, dynamic> filterParameters,
  }) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio.get(
          ApiKeys.therapistListUrlQuery(
              sortByAttribute: attributeName,
              pageNumber: pageNumber,
              direction: direction,
              pageSize: pageSize),
          queryParameters: filterParameters);

      TherapistListWrapper wrapper =
          TherapistListWrapper.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log(onError.toString());
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  static Future<void> therapistBookedBeforeApi(
    void Function(TherapistsBookedBeforeWrapper) success,
    void Function(NetworkExceptions) fail,
  ) async {
    try {
      await BaseApi.updateHeader();
      final response =
          await BaseApi.dio.post(ApiKeys.clientTherapistBookedBeforeListUrl);

      TherapistsBookedBeforeWrapper wrapper =
          TherapistsBookedBeforeWrapper.fromJson(response.data);
      if (wrapper.errorCode == 0 || wrapper.errorCode == 11) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log(onError.toString());
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  static Future<void> getMinMax(
    void Function(MinMaxWrapper) success,
    void Function(NetworkExceptions) fail,
  ) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio.get(ApiKeys.minMax());
      MinMaxWrapper wrapper = MinMaxWrapper.fromMap(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log(onError.toString());
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  static Future<void> verifyUserIsCorporateApi(
    void Function(VerifyUserIsCorporateWrapper) success,
    void Function(NetworkExceptions) fail,
  ) async {
    try {
      await BaseApi.updateHeader();
      var companyCode = await PrefManager.getCompanyCode();
      var verifyUserUrl = ApiKeys.verifyUserIsCorporateUrl;
      if (companyCode != null && companyCode.isNotEmpty) {
        verifyUserUrl += "/$companyCode";
      }
      final response = await BaseApi.dio.get(verifyUserUrl);
      VerifyUserIsCorporateWrapper wrapper =
          VerifyUserIsCorporateWrapper.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log(onError.toString());
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  static Future<void> therapistListGuestApi(
    void Function(GuestTherapistList) success,
    void Function(NetworkExceptions) fail, {
    int pageNumber = 1,
    int pageSize = 4,
  }) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio.get(ApiKeys.therapistListGuestUrlQuery(
          pageNumber: pageNumber, pageSize: pageSize));

      GuestTherapistList wrapper = GuestTherapistList.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log(onError.toString());
      fail(NetworkExceptions.getDioException(onError));
    }
  }
}
