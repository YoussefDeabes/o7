import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/api/models/ip_api/ip_api_model.dart';

import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:sendbird_sdk/utils/extensions.dart';

class AuthHeader {
  const AuthHeader._();

  static Future<Map<String, dynamic>> getLoginSignUpHeaders() async {
    final String? langKey = await PrefManager.getLang();

    final response =
        await Dio().get("https://ipapi.co/json/?key=${ApiKeys.ipApiKey}");

    IpApiDataModel ipApiModel = IpApiDataModel.fromJson(response.data);
    PrefManager.setCountryCode(ipApiModel.countryCodeIso3!);
    return {
      ApiKeys.timeZone: ipApiModel.timezone,
      ApiKeys.authorization: null,
      ApiKeys.accept: ApiKeys.applicationJson,
      ApiKeys.locale: langKey ?? 'en',
      ApiKeys.language: 'en',
      ApiKeys.version: '1',
      ApiKeys.country: ipApiModel.countryCodeIso3,
      ApiKeys.utcOffset: _getUtcOffset(),
      ApiKeys.timezone: ipApiModel.timezone,
      ApiKeys.platform: Platform.isAndroid ? 'android' : 'ios',
    };
  }

  static int _getUtcOffset() {
    DateTime dateTime = DateTime.now();
    var offset = dateTime.toLocal().timeZoneOffset;
    int utcOffsetInMinute = offset.inMinutes * -1;
    return utcOffsetInMinute;
  }
}
