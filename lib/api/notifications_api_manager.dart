import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/api/base/base_api_manager.dart';
import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/models/notifications/notifications.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/util/notifications/firebase_token.dart';

import 'models/notifications/unread_notifications_count/unread_notifications_count_model.dart';

class NotificationsApiManager {
  static Future<void> getNotifications({
    required void Function(NotificationsWrapper) success,
    required void Function(NetworkExceptions) fail,
  }) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio.get(
        ApiKeys.notifications,
        // queryParameters: {"page_size": 10, "page_number": 30},
      );
      NotificationsWrapper wrapper =
          NotificationsWrapper.fromJson(response.data);
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

  static Future<void> markAllAsRead({
    required void Function(NotificationsMarkAllAsReadWrapper) success,
    required void Function(NetworkExceptions) fail,
  }) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio.put(ApiKeys.markAllAsRead);
      NotificationsMarkAllAsReadWrapper wrapper =
          NotificationsMarkAllAsReadWrapper.fromJson(response.data);
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

  static Future<void> getUnreadNotificationsCount({
    required void Function(UnreadNotificationCountModel) success,
    required void Function(NetworkExceptions) fail,
  }) async {
    try {
      await BaseApi.updateHeader();
      final response = await BaseApi.dio.get(ApiKeys.unreadNotificationsCount);
      UnreadNotificationCountModel wrapper =
          UnreadNotificationCountModel.fromJson(response.data);
      log(json.encode(response.data));
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

  static Future<void> registerForNotificationApi() async {
    try {
      await BaseApi.updateHeader();

      // get the token depending on the the device type
      String? stringToken = await _getFirebaseToken();
      String? userId = await PrefManager.getId();
      String? deviceId = await _getDeviceId();

      log("deviceId :: $deviceId");
      final response = await BaseApi.dio.post(
        ApiKeys.pushForNotification,
        options: Options(
          headers: BaseApi.dio.options.headers
            ..update(ApiKeys.platform, (value) => 'android'),
        ),
        data: {
          'user_id': userId!,
          'device_id': deviceId,
          "push_notification_token": stringToken,
        },
      );
      log("pushForNotification request Data: ${response.requestOptions.data}");
      log("pushForNotification response Data: ${response.data}");
    } catch (e) {
      log("some Wrong");
    }
  }

  static Future<String?> _getFirebaseToken() async {
    return FirebaseToken.instance.getToken();
  }

  static Future<String?> _getDeviceId() async {
    try {
      final deviceInfoPlugin = DeviceInfoPlugin();
      if (Platform.isIOS) {
        final iosDeviceInfo = await deviceInfoPlugin.iosInfo;
        return iosDeviceInfo.identifierForVendor; // unique ID on iOS
      } else if (Platform.isAndroid) {
        final androidDeviceInfo = await deviceInfoPlugin.androidInfo;
        return androidDeviceInfo.id; // unique ID on Android
      }
    } on PlatformException {
      return 'Failed to get deviceId.';
    }
    return null;
  }
}
