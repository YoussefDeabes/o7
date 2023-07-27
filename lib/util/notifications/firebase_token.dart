import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';

class FirebaseToken {
  FirebaseToken._();
  static final FirebaseToken _instance = FirebaseToken._();
  static FirebaseToken get instance => _instance;

  String? _token;
  String? _apnsToken;
  Stream<String>? _tokenStream;

  /// Manages & returns the users FCM token.
  Future<String?> getToken() async {
    if (_token != null) {
      return _token;
    }
    try {
      _token = await FirebaseMessaging.instance.getToken();
      _fcmTokenStream();
      log("FCM: $_token");
      return _token;
    } catch (e) {
      log("getToken: $e");
      return _token;
    }
  }

  Future<String?> getAPNSToken() async {
    if (_apnsToken != null) {
      return _apnsToken;
    }
    try {
      if (Platform.isIOS) {
        log('FlutterFire Messaging Example: Getting APNs token...');
        _apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        log('FlutterFire Messaging Example: Got APNs token: $_token');
      }
      return _apnsToken;
    } catch (e) {
      log("getToken: $e");
      return _apnsToken;
    }
  }

  /// Also monitors token refreshes and updates state.
  void _fcmTokenStream() {
    if (_tokenStream == null) {
      _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
      _tokenStream!.listen((String token) {
        _token = token;
        Freshchat.setPushRegistrationToken(token);
      });
    }
  }
}
