import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:o7therapy/util/notifications/firebase_messaging_background_handler.dart';
import 'package:o7therapy/util/notifications/firebase_messaging_on_message_handler.dart';
import 'package:o7therapy/util/notifications/firebase_token.dart';

import 'background_notification/background_local_notifications.dart';

class NotificationsServices {
  NotificationsServices._();
  static final NotificationsServices _instance = NotificationsServices._();
  static NotificationsServices get instance => _instance;
  FirebaseMessaging get _message => FirebaseMessaging.instance;

  Future<void> init() async {
    /// Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await _message.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    await _message.setAutoInitEnabled(true);
    await requestPermissions();

    /// enableNotificationStream
    FirebaseMessaging.onMessage.listen(firebaseMessagingOnMessageHandler);

    await FirebaseToken.instance.getToken();

    onMessageOpenedApp();

    if (!kIsWeb) {
      await BackgroundLocalNotifications.instance.setupFlutterNotifications();
    }
  }

  static void onMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('notification:: A new onMessageOpenedApp event was published!');
      // Navigator.pushNamed(context, HomeScreen.routeName);
    });
  }

  late NotificationSettings _settings;

  /// Requests & displays the current user permissions for this device.
  Future<void> requestPermissions() async {
    _settings = await _message.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );
    log('User granted permission: ${_settings.authorizationStatus}');
    log('User granted permission: ${_settings.authorizationStatus}');
  }

  Future<void> checkPermissions() async {
    _settings = await _message.getNotificationSettings();
  }
}

/// Maps a [AuthorizationStatus] to a string value.
const statusMap = {
  AuthorizationStatus.authorized: 'Authorized',
  AuthorizationStatus.denied: 'Denied',
  AuthorizationStatus.notDetermined: 'Not Determined',
  AuthorizationStatus.provisional: 'Provisional',
};

/// Maps a [AppleNotificationSetting] to a string value.
const settingsMap = {
  AppleNotificationSetting.disabled: 'Disabled',
  AppleNotificationSetting.enabled: 'Enabled',
  AppleNotificationSetting.notSupported: 'Not Supported',
};

/// Maps a [AppleShowPreviewSetting] to a string value.
const previewMap = {
  AppleShowPreviewSetting.always: 'Always',
  AppleShowPreviewSetting.never: 'Never',
  AppleShowPreviewSetting.notSupported: 'Not Supported',
  AppleShowPreviewSetting.whenAuthenticated: 'Only When Authenticated',
};
