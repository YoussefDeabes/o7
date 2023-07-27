import 'dart:io';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:o7therapy/ui/screens/notifications/model/send_bird_message_model.dart';
import 'package:o7therapy/util/notifications/background_notification/android_channels.dart';

class BackgroundLocalNotifications {
  BackgroundLocalNotifications._();
  static final BackgroundLocalNotifications _instance =
      BackgroundLocalNotifications._();

  static BackgroundLocalNotifications get instance => _instance;

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool _isFlutterLocalNotificationsInitialized = false;

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) {
      return;
    }
    AndroidChannels.init();

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await initSettings();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(AndroidChannels.mainChannel);
    }

    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> initSettings() async {
    const android = AndroidInitializationSettings('app_logo');
    const ios = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: null);
    const settings = InitializationSettings(android: android, iOS: ios);
    await flutterLocalNotificationsPlugin.initialize(
      settings,
      //    onSelectNotification: ((payload) async {
      //   onNotifications.add(payload);
      // })
    );
  }

  void showFlutterNotification(RemoteMessage message) {
    log("show flutter notification");
    RemoteNotification? notification = message.notification;
    if (notification != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        _notificationDetails,
      );
    }
  }

  void showSendBirdNotification(SendBirdMessageModel message) {
    SendBirdModel notification = message.sendBird;
    if (!kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        "${notification.channel.channelUnreadMessageCount} UnRead Message From Therapist",
        notification.message,
        _notificationDetails,
      );
    }
  }

  NotificationDetails get _notificationDetails => NotificationDetails(
        android: AndroidNotificationDetails(
          AndroidChannels.mainChannel.id,
          AndroidChannels.mainChannel.name,
          importance: AndroidChannels.mainChannel.importance,
          channelDescription: AndroidChannels.mainChannel.description,
          priority: Priority.max,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: 'app_logo',
        ),
        iOS: const DarwinNotificationDetails(presentSound: true),
      );
}

// static final notifications = FlutterLocalNotificationsPlugin();
// /// init local notification
// Future initLocal({bool initSchedule = false}) async {
//   const android = AndroidInitializationSettings('app_logo');
//   const ios = IOSInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//       onDidReceiveLocalNotification: null);
//   const settings = InitializationSettings(android: android, iOS: ios);
//   await flutterLocalNotificationsPlugin.initialize(
//     settings,
//     /* onSelectNotification: ((payload) async {
//       onNotifications.add(payload);
//     })*/
//   );
// }

  // // show local notification
  // Future showNotification({
  //   int id = 0,
  //   String? title,
  //   String? body,
  //   String? payLoad,
  // }) async {
  //   await flutterLocalNotificationsPlugin
  //       .show(id, title, body, await getNotificationDetails(), payload: payLoad)
  //       .catchError((ex) {
  //     if (kDebugMode) {
  //       print("notification error : ${ex.toString()}");
  //     }
  //   });
  // }

  // // local notification details
  // Future getNotificationDetails() async {
  //   return const NotificationDetails(
  //       android: AndroidNotificationDetails("channelId", "channelName",
  //           channelDescription: "",
  //           importance: Importance.max,
  //           playSound: true),
  //       iOS: IOSNotificationDetails(presentSound: true));
  // }