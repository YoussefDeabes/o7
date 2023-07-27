import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/api/base/base_api_manager.dart';
import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/models/forget_password/forgot_password_wrapper.dart';

class ForgetPasswordApiManager {
  static Future<void> sendForgotPasswordApi({
    required String email,
    required void Function() success,
    required void Function(NetworkExceptions) fail,
  }) async {
    try {
      final response = await BaseApi.dio.put(
        ApiKeys.sendForgotPasswordUrl,
        data: {"user_email": email},
      );
      ForgotPasswordWrapper wrapper =
          ForgotPasswordWrapper.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success();
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  static Future<void> forgotPasswordCodeVerificationApi({
    required String email,
    required String code,
    required void Function(String?) success,
    required void Function(NetworkExceptions) fail,
  }) async {
    try {
      final response = await BaseApi.dio.put(
        ApiKeys.verifyForgotPasswordCodeUrl,
        data: {
          "user_email": email,
          "code": code,
        },
      );
      ForgotPasswordWrapper wrapper =
          ForgotPasswordWrapper.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper.userReferenceNumber);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  static Future<void> forgotPasswordVerificationApi({
    required Map<String, dynamic> data,
    required void Function() success,
    required void Function(NetworkExceptions) fail,
  }) async {
    try {
      final response = await BaseApi.dio.put(
        ApiKeys.updateForgotPasswordVerificationUrl,
        data: data,
      );
      ForgotPasswordWrapper wrapper =
          ForgotPasswordWrapper.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success();
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      fail(NetworkExceptions.getDioException(onError));
    }
  }
}
