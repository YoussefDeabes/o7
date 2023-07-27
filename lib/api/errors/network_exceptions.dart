import 'dart:io';

import 'package:dio/dio.dart';
import 'package:o7therapy/api/errors/exception_types.dart';

class NetworkExceptions {
  /// backend error ...
  int? errorCode;
  final String? errorMsg;
  final String? errorDetails;

  /// in case you need to add custom message ...
  String get customErrorMessage => "";

  String? getErrorMassage() {
    return errorMsg!.isNotEmpty ? errorMsg : errorDetails;
  }

  NetworkExceptions(this.errorCode, this.errorMsg, this.errorDetails);

  NetworkExceptions.fromJson(Map<String, dynamic> json)
      : errorCode = (json['error_code'] ?? -1) as int,
        errorMsg = (json['error_msg'] ?? "") as String,
        errorDetails = (json['error_details'] ?? "") as String;

  static NetworkExceptions getDioException(error) {
    if (error is Exception || error is DioError) {
      try {
        NetworkExceptions networkExceptions;
        if (error is DioError) {
          switch (error.type) {
            case DioErrorType.cancel:
              networkExceptions = RequestCancelled(
                  error.response?.data as Map<String, dynamic>);
              break;
            case DioErrorType.connectTimeout:
              networkExceptions =
                  RequestTimeout(error.response?.data as Map<String, dynamic>);
              break;
            case DioErrorType.other:
              networkExceptions = NoInternetConnection();
              break;
            case DioErrorType.receiveTimeout:
              networkExceptions =
                  SendTimeout(error.response?.data as Map<String, dynamic>);
              break;
            case DioErrorType.response:
              networkExceptions = getResponseException(error);
              break;
            case DioErrorType.sendTimeout:
              networkExceptions =
                  SendTimeout(error.response?.data as Map<String, dynamic>);
              break;
          }
        } else if (error is SocketException) {
          networkExceptions = UnExpectedError();
        } else {
          networkExceptions = UnexpectedError();
        }
        return networkExceptions;
      } catch (e) {
        return UnexpectedError();
      }
    } else {
      return UnexpectedError();
    }
  }

  static NetworkExceptions getResponseException(DioError error) {
    switch (error.response?.statusCode) {
      case 400:
        return UnauthorizedRequest();
      case 401:
        return UnauthorizedRequest();
      case 403:
        return UnauthorizedRequest();
      case 404:
        return NotFound(error.response?.data as Map<String, dynamic>);
      case 409:
        return Conflict(error.response?.data as Map<String, dynamic>);
      case 408:
        return RequestTimeout(error.response?.data as Map<String, dynamic>);
      case 422:
        return UnProcessableEntity(
            error.response?.data as Map<String, dynamic>);
      case 500:
        return InternalServerError(
            error.response?.data as Map<String, dynamic>);
      case 503:
        return ServiceUnavailable(error.response?.data as Map<String, dynamic>);
      default:
        return UnexpectedError();
    }
  }
}
