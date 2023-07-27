import 'dart:developer';
import 'dart:io';

import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:o7therapy/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:o7therapy/ui/screens/notifications/model/send_bird_message_model.dart';

import 'background_notification/background_local_notifications.dart';

/// Working example of FirebaseMessaging.
/// Please use this in order to verify messages are working in foreground, background & terminated state.
/// Setup your app following this guide:
/// https://firebase.google.com/docs/cloud-messaging/flutter/client#platform-specific_setup_and_requirements):
///
/// Once you've completed platform specific requirements, follow these instructions:
/// 1. Install melos tool by running `flutter pub global activate melos`.
/// 2. Run `melos bootstrap` in FlutterFire project.
/// 3. In your terminal, root to ./packages/firebase_messaging/firebase_messaging/example directory.
/// 4. Run `flutterfire configure` in the example/ directory to setup your app with your Firebase project.
/// 5. Run the app on an actual device for iOS, android is fine to run on an emulator.
/// 6. Use the following script to send a message to your device: scripts/send-message.js. To run this script,
///    you will need nodejs installed on your computer. Then the following:
///     a. Download a service account key (JSON file) from your Firebase console, rename it to "google-services.json" and add to the example/scripts directory.
///     b. Ensure your device/emulator is running, and run the FirebaseMessaging example app using `flutter run`.
///     c. Copy the token that is printed in the console and paste it here: https://github.com/firebase/flutterfire/blob/01b4d357e1/packages/firebase_messaging/firebase_messaging/example/lib/main.dart#L32
///     c. From your terminal, root to example/scripts directory & run `npm install`.
///     d. Run `npm run send-message` in the example/scripts directory and your app will receive messages in any state; foreground, background, terminated.
///  Note: Flutter API documentation for receiving messages: https://firebase.google.com/docs/cloud-messaging/flutter/receive
///  Note: If you find your messages have stopped arriving, it is extremely likely they are being throttled by the platform. iOS in particular
///  are aggressive with their throttling policy.
///
/// To verify that your messages are being received, you ought to see a notification appear on your device/emulator via the flutter_local_notifications plugin.
/// Define a top-level named handler which background/terminated messages will
/// call. Be sure to annotate the handler with `@pragma('vm:entry-point')` above the function declaration.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

// make sure you call `initializeApp` before using other Firebase services.
  log('Handling a background message notification?.body:${message.notification?.body}');
  log('Handling a background message data:${message.data}');

  /// _check Is this notification is FreshchatNotification
  /// then handle it by freshChat
  if (await (_checkIsFreshchatNotification(message))) {
    return;
  }

  /// if the device is Android && if the message.notification exist (not null)
  /// it will handled by default >> no need to flutter local notification package
  /// else (device is ios) || (notification == null)
  /// here need to handle by local notification package
  if (message.notification == null || !Platform.isAndroid) {
    await BackgroundLocalNotifications.instance.setupFlutterNotifications();

    /// check if send bird message or not
    /// if send bird notification it will handle
    if (_checkSendBirdMessage(message)) {
      return;
    }

    /// the last state if not freshchat notification or sendbird
    BackgroundLocalNotifications.instance.showFlutterNotification(message);
  }
}

bool _checkSendBirdMessage(RemoteMessage message) {
  if (message.data["sendbird"] == null) {
    return false;
  } else if (!SendBirdMessageModel.isSendBirdMessageModel(message.data)) {
    return false;
  } else {
    try {
      SendBirdMessageModel sendBirdMessageModel =
          SendBirdMessageModel.fromMap(message.data);

      BackgroundLocalNotifications.instance
          .showSendBirdNotification(sendBirdMessageModel);
      return true;
    } catch (e) {
      return false;
    }
  }
}

Future<bool> _checkIsFreshchatNotification(RemoteMessage message) async {
  if (await Freshchat.isFreshchatNotification(message.data)) {
    log("is Freshchat notification: $message");

    Freshchat.handlePushNotification(message.data);

    return true;
  } else {
    return false;
  }
}
