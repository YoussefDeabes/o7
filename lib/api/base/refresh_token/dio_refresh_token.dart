import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/api/base/base_api_manager.dart';
import 'package:o7therapy/api/base/dio_firebase_performance_interceptor.dart';
import 'package:o7therapy/api/base/interceptors.dart';
import 'package:o7therapy/api/models/auth/refresh_token/refresh_token_wrapper.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/util/secure_storage_helper/secure_storage.dart';

class DioRefreshToken {
  static String? _langKey;
  static String? _refreshTokenString;

  static Dio get dio {
    Dio dio = Dio();
    dio.interceptors.add(DioFirebasePerformanceInterceptor());
    if (kDebugMode) {
      dio.interceptors.add(customLoginInterceptor);
    } else {
      dio.interceptors.remove(customLoginInterceptor);
    }
    return dio;
  }

  static Map<String, dynamic> get headers {
    return {
      ApiKeys.accept: ApiKeys.applicationJson,
      ApiKeys.locale: _langKey ?? 'en',
      ApiKeys.language: _langKey ?? 'en',
      ApiKeys.version: '1',
      ApiKeys.platform: Platform.isAndroid ? 'android' : 'ios',
    };
  }

  static Map<String, dynamic> get data {
    return {
      "client_id": ApiKeys.clientId,
      "client_secret": ApiKeys.appSecret,
      "grant_type": "refresh_token",
      "refresh_token": _refreshTokenString,
      "platform": Platform.isAndroid ? 'android' : 'ios',
    };
  }

  static Future<bool> refreshToken() async {
    try {
      _refreshTokenString = await PrefManager.getRefreshToken();
      _langKey = await PrefManager.getLang();
      log("old refreshToken is $_refreshTokenString old accessToken is ${await PrefManager.getToken()}");
      final response = await dio.post(
        ApiKeys.refreshTokenUrl,
        options: Options(headers: headers),
        data: data,
      );
      log("refreshToken response");
      if (response.statusCode == 200 || response.statusCode == 201) {
        RefreshTokenWrapper wrapper =
            RefreshTokenWrapper.fromJson(response.data);
        await PrefManager.setRefreshToken(wrapper.data?.refreshToken);
        await SecureStorage.setRefreshToken(wrapper.data?.refreshToken);
        await PrefManager.setToken(wrapper.data?.accessToken);
        await SecureStorage.setToken(wrapper.data?.accessToken);
        await BaseApi.updateHeader();

        log("updated refreshToken is ${await PrefManager.getRefreshToken()}");
        log("updated accessToken is ${await PrefManager.getToken()}");
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
}
