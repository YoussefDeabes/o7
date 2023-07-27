import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/api/base/base_api_manager.dart';
import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/models/insurance/added_insurance_card/added_insurance_card_model.dart';
import 'package:o7therapy/api/models/insurance/deleted_insurance_card/deleted_insurance_card_model.dart';
import 'package:o7therapy/api/models/insurance/get_insurance_card/get_insurance_card.dart';
import 'package:o7therapy/api/models/insurance/insurance_providers_list/insurance_providers_list.dart';
import 'package:o7therapy/api/models/insurance/model/phone_masked_number_model.dart';
import 'package:o7therapy/api/models/insurance/remaining_cap_no/remaining_cap_no_model.dart';
import 'package:o7therapy/api/models/insurance/resend_verification_code_for_insurance/resend_verification_code_for_insurance.dart';
import 'package:o7therapy/api/models/insurance/update_insurance_card/update_insurance_card_model.dart';
import 'package:o7therapy/api/models/insurance/validate_otp_insurance_card/validate_otp_insurance_card_wrapper.dart';
import 'package:o7therapy/ui/screens/insurance/models/update_insurance_card_params.dart';

class InsuranceApiManager {
  static Future<void> getInsuranceProvidersList({
    required void Function(InsuranceProvidersWrapper) success,
    required void Function(NetworkExceptions) fail,
  }) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio.get(ApiKeys.insuranceProvidersList);
      log(jsonEncode(response.data));
      final InsuranceProvidersWrapper wrapper =
          InsuranceProvidersWrapper.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log("Print Log Error while get insuranceProvidersList", error: onError);
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  /// add insurance card
  /// returns true >> if the insurance is valid >>
  /// then if you need to get insurance data >> must ues Get the insurance card
  /// else null or false no
  static Future<void> addInsuranceCard({
    required int providerId,
    required String membershipNumber,
    required void Function(AddedInsuranceCardWrapper) success,
    required void Function(NetworkExceptions) fail,
  }) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio.post(
        ApiKeys.addInsuranceCard,
        data: {
          'medical_card_number': membershipNumber,
          "insurance_company_id": providerId,
        },
      );
      final AddedInsuranceCardWrapper wrapper =
          AddedInsuranceCardWrapper.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log("on Error:", error: onError);
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  /// get all details about the insurance card
  static Future<void> getInsuranceCard({
    required void Function(GetInsuranceCardWrapper) success,
    required void Function(NetworkExceptions) fail,
  }) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio.get(ApiKeys.getInsuranceCard);
      final GetInsuranceCardWrapper wrapper =
          GetInsuranceCardWrapper.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log("on Error:", error: onError);
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  /// delete insurance card
  static Future<void> deleteInsuranceCard({
    required int cardId,
    required void Function(DeletedInsuranceCardWrapper) success,
    required void Function(NetworkExceptions) fail,
  }) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio.put(
        ApiKeys.deleteCard,
        data: {"card_id": cardId},
      );
      final DeletedInsuranceCardWrapper wrapper =
          DeletedInsuranceCardWrapper.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log("on Error:", error: onError);
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  /// resend verification to validate the card again >>
  /// 1. add the card 2. get the card
  /// >> returns true when resend Verification Code
  static Future<void> resendVerificationCode({
    required int cardNumber,
    required void Function(ResendVerificationCodeForInsuranceModel) success,
    required void Function(NetworkExceptions) fail,
  }) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio.post(
        ApiKeys.resendVerificationCode,
        queryParameters: {"card_number": cardNumber},
      );
      final ResendVerificationCodeForInsuranceModel wrapper =
          ResendVerificationCodeForInsuranceModel.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log("on Error:", error: onError);
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  /// validate the card otp >>
  /// 1. add the card
  /// 2. get the card
  /// 3. validate the card
  /// data returned is bool
  /// true >> then the user validation is Right then get the remaining data
  /// else >> then the user validation is wrong
  static Future<void> validateOtpInsuranceCard({
    required String otp,
    required String cardNumber,
    required void Function(ValidateOtpInsuranceWrapper) success,
    required void Function(NetworkExceptions) fail,
  }) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio.post(
        ApiKeys.validateCardOtp,
        data: {"otp": otp, "card_number": cardNumber},
      );
      final ValidateOtpInsuranceWrapper wrapper =
          ValidateOtpInsuranceWrapper.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log("on Error:", error: onError);
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  /// update a card
  /// 1. get the provider id from list of providers
  /// 2. let the user enter new card number
  /// 3. send the oldUserCardId <<current used>>
  /// 4. call update the card. // the verification will send automatically form bk-end
  /// 5. so show to user the verification to
  static Future<void> updateInsuranceCard({
    required UpdateInsuranceCardParams params,
    required void Function(UpdateInsuranceCardWrapper) success,
    required void Function(NetworkExceptions) fail,
  }) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio.put(
        ApiKeys.updateInsuranceCard,
        data: params.toDataMap(),
      );
      final UpdateInsuranceCardWrapper wrapper =
          UpdateInsuranceCardWrapper.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log("on Error:", error: onError);
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  static Future<void> getRemainingInsuranceCard({
    required void Function(RemainingCapNoModel) success,
    required void Function(NetworkExceptions) fail,
  }) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio.get(ApiKeys.getRemainingInsuranceCard);
      log(json.encode(response.data));
      final RemainingCapNoModel wrapper =
          RemainingCapNoModel.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log("on Error:", error: onError);
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  static Future<void> getPhoneMaskedNumberApi({
    required String cardNumber,
    required void Function(PhoneMaskedNumberModel) success,
    required void Function(NetworkExceptions) fail,
  }) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio.get(
        ApiKeys.getCardMaskedNumberUrl,
        queryParameters: {"card_number": int.parse(cardNumber)},
      );
      final PhoneMaskedNumberModel wrapper =
          PhoneMaskedNumberModel.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      log("on Error:", error: onError);
      fail(NetworkExceptions.getDioException(onError));
    }
  }
}

/// Examples:
///
/// bobyan >> 1234567890
///

// InsuranceApiManager.resendVerificationCode(
//   cardNumber: 213,
//   fail: (detailsApiModel) {},
//   success: (wrapper) {},
// );

// InsuranceApiManager.validateOtpInsuranceCard(
//   cardNumber: "1234567890",
//   otp: "7691",
//   fail: (detailsApiModel) {},
//   success: (wrapper) {},
// );

// InsuranceApiManager.updateInsuranceCard(
//   insuranceCompanyId: 1,
//   medicalCardNumber: "1234567890",
//   oldUserCardId: 72,
// );

// InsuranceApiManager.deleteInsuranceCard(
//   cardId: 100,
//   fail: (detailsApiModel) {},
//   success: (wrapper) {},
// );

// InsuranceApiManager.getInsuranceCard(
//   fail: (detailsApiModel) {},
//   success: (wrapper) {},
// );

// InsuranceApiManager.addInsuranceCard(
//   providerId: InsuranceScreenBloc.getBloc(context)
//       .insuranceData
//       .providerData!
//       .providerId,
//   membershipNumber: membershipNumberController.text,
//   fail: (detailsApiModel) {},
//   success: (wrapper) {},
// );
