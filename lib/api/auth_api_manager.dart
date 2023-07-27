import 'package:dio/dio.dart';
import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/api/auth_header.dart';
import 'package:o7therapy/api/base/base_api_manager.dart';
import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/models/auth/check_verified_email/check_verified_email.dart';
import 'package:o7therapy/api/models/auth/login/LoginWrapper.dart';
import 'package:o7therapy/api/models/auth/login/login_send_model.dart';
import 'package:o7therapy/api/models/auth/my_profile/my_profile_wrapper.dart';
import 'package:o7therapy/api/models/auth/send_verification_email/send_verification_email_wrapper.dart';
import 'package:o7therapy/api/models/auth/sign_up_models/sign_up_models.dart';
import 'package:o7therapy/api/models/auth/verify_client_email/verify_client_email_wrapper.dart';

class AuthApiManager {
  static Future<void> loginApi(
      LoginSendModel loginModel,
      void Function(LoginWrapper) success,
      void Function(NetworkExceptions) fail) async {
    Map<String, dynamic>? headers = await AuthHeader.getLoginSignUpHeaders();
    await BaseApi.dio
        .post(
      ApiKeys.loginUrl,
      data: loginModel.toMap(),
      options: Options(headers: headers),
    )
        .then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      LoginWrapper wrapper = LoginWrapper.fromJson(extractedData);
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

  static Future<void> signUpApi(
      SignUpSendModel signUpSendModel,
      void Function(SignUpWrapper) success,
      void Function(NetworkExceptions) fail) async {
    try {
      Map<String, dynamic>? headers = await AuthHeader.getLoginSignUpHeaders();
      final response = await BaseApi.dio.post(
        ApiKeys.signUpUrl,
        data: signUpSendModel.toMap(),
        options: Options(headers: await AuthHeader.getLoginSignUpHeaders()),
      );
      SignUpWrapper wrapper = SignUpWrapper.fromJson(response.data);
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

  /// used this end point in the login only
  /// check if the user current email is verified or not after log in
  /// if not verified after log in then navigate the user to verify screen to verify his mail first
  /// then >> navigate to home screen page
  static Future<void> checkVerifiedEmailApi({
    required String userId,
    required void Function(CheckVerifiedEmailWrapper) success,
    required void Function(NetworkExceptions) fail,
  }) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio.get(
        ApiKeys.checkVerifiedEmail,
        queryParameters: {"user_id": userId},
      );
      CheckVerifiedEmailWrapper wrapper =
          CheckVerifiedEmailWrapper.fromJson(response.data);
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

  /// verify the email of the user
  static Future<void> verifyClientEmailApi({
    required String userId,
    required String code,
    required void Function(VerifyClientEmailWrapper) success,
    required void Function(NetworkExceptions) fail,
  }) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio.get(
        ApiKeys.verifyClientEmailUrl,
        queryParameters: {"user_id": userId, "code": code},
      );
      VerifyClientEmailWrapper wrapper =
          VerifyClientEmailWrapper.fromJson(response.data);
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

  static Future<void> resendVerificationCodeEmailApi({
    required String userId,
    required void Function(SendVerificationEmailWrapper) success,
    required void Function(NetworkExceptions) fail,
  }) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio.post(
        ApiKeys.resendVerificationCodeEmail,
        data: {"user_id": userId},
      );
      SendVerificationEmailWrapper wrapper =
          SendVerificationEmailWrapper.fromJson(response.data);
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
}
