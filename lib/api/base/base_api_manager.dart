import 'dart:collection';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/api/models/auth/refresh_token/refresh_token_wrapper.dart';
import 'package:o7therapy/bloc/internet_connection_bloc/internet_connection_bloc.dart';
import 'package:o7therapy/api/base/dio_firebase_performance_interceptor.dart';
import 'package:o7therapy/api/base/interceptors.dart';
import 'package:o7therapy/api/base/refresh_token/dio_refresh_token.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/util/general.dart';
import 'package:o7therapy/util/secure_storage_helper/secure_storage.dart';

class BaseApi extends BaseOptions {
  static String? accessToken;
  static String? langKey;
  static final pathsQueue = Queue<String>();

  static Dio get dio {
    Dio updatedDio = _dioInstance()
      ..interceptors.addAll([
        DioFirebasePerformanceInterceptor(),
        InterceptorsWrapper(
          onError: (DioError error, handler) async {
            if (error.response?.statusCode == 401) {
              String? refreshToken = await PrefManager.getRefreshToken();
              if (refreshToken != null) {
                bool isTokenRefreshed = await DioRefreshToken.refreshToken();
                if (isTokenRefreshed) {
                  return handler.resolve(await _retry(error.requestOptions));
                }
              }
            }
            return handler.next(error);
          },
        )
      ]);

    if (isDebugMode()) {
      return updatedDio..interceptors.add(customLoginInterceptor);
    } else {
      return updatedDio;
    }
  }

  static Future<void> updateHeader() async {
    accessToken = await PrefManager.getToken();
    langKey = await PrefManager.getLang();
  }

  static Dio _dioInstance() {
    return Dio(BaseApi());
  }

  static Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    try {
      /// update the access token in the header and then retry
      Map<String, dynamic> updatedHeaders = requestOptions.headers;
      // update the token >>> must be updated >> before retry the same request
      String? updatedAccessToken = await PrefManager.getToken();
      log("old access token is ${requestOptions.headers[ApiKeys.authorization]}");
      log("new access token is $updatedAccessToken");
      updatedHeaders.update(ApiKeys.authorization,
          (_) => '${ApiKeys.keyBearer} $updatedAccessToken');
      // update the header again just for more check
      await updateHeader();
      final options = Options(
        method: requestOptions.method,
        headers: updatedHeaders,
      );
      return await dio.request<dynamic>(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Map<String, dynamic> get headers {
    Map<String, dynamic> header = {};
    header.putIfAbsent(ApiKeys.accept, () => ApiKeys.applicationJson);
    header.putIfAbsent(
        ApiKeys.authorization, () => '${ApiKeys.keyBearer} $accessToken');
    header.putIfAbsent(ApiKeys.locale, () => langKey ?? 'en');
    header.putIfAbsent(ApiKeys.language, () => langKey ?? 'en');
    header.putIfAbsent(ApiKeys.version, () => '1');
    header.putIfAbsent(
        ApiKeys.platform, () => Platform.isAndroid ? 'android' : 'ios');
    return header;
  }

  @override
  String get contentType => super.contentType!;

  @override
  String get baseUrl => ApiKeys.baseUrl;

  static Future<bool> _refreshToken() async {
    try {
      final refreshToken = await PrefManager.getRefreshToken();
      log("old refresh Token is $refreshToken");
      log("old access token is ${await PrefManager.getToken()}");
      Map<String, dynamic> updatedHeaders = dio.options.headers;
      updatedHeaders.remove(ApiKeys.authorization);
      Dio refreshDio = Dio()
        ..interceptors.add(
          LogInterceptor(responseBody: true, requestBody: true, error: true),
        );
      final response = await refreshDio.post(
        ApiKeys.refreshTokenUrl,
        options: Options(headers: updatedHeaders),
        data: {
          "client_id": ApiKeys.clientId,
          "client_secret": ApiKeys.appSecret,
          "grant_type": "refresh_token",
          "refresh_token": refreshToken,
          "platform": Platform.isAndroid ? 'android' : 'ios',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        RefreshTokenWrapper wrapper =
            RefreshTokenWrapper.fromJson(response.data);
        await PrefManager.setRefreshToken(wrapper.data?.refreshToken);
        await SecureStorage.setRefreshToken(wrapper.data?.refreshToken);
        await PrefManager.setToken(wrapper.data?.accessToken);
        await SecureStorage.setToken(wrapper.data?.accessToken);
        log("updated refreshToken is ${await PrefManager.getRefreshToken()}");
        log("updated accessToken is ${await PrefManager.getToken()}");
        updateHeader();
        return true;
      } else {
        log("clear all data token not update ");
        PrefManager.clearAllData();
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<void> _onRequestInterceptor(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // check if this request is called before
    // return
    // else add the request to the queue so that
    // the request will not be called more than one time
    bool isQueueContainsThisOption = pathsQueue.any(
      (String path) => path == options.path,
    );
    if (isQueueContainsThisOption) {
      return;
    } else {
      pathsQueue.add(options.path);
    }
    // if the user closed the wifi and network data
    // then stuck here
    while (!InternetConnectionBloc.currentState.isConnected) {
      await Future.delayed(const Duration(seconds: 2));
    }
    pathsQueue.removeWhere(
      (String path) => path == options.path,
    );
    return handler.next(options);
  }

  static Future<void> _onResponseInterceptor(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    // remove the requestOptions from the queue
    // so the user can call the same end point again
    pathsQueue.removeWhere(
      (String path) => path == response.requestOptions.path,
    );
    return handler.next(response);
  }
}
