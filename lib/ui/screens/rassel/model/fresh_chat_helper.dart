import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:freshchat_sdk/freshchat_user.dart';
import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/util/notifications/firebase_token.dart';
import 'package:o7therapy/util/secure_storage_helper/secure_storage.dart';

class FreshChatHelper {
  FreshChatHelper._();
  static FreshChatHelper? _i;
  static FreshChatHelper get instance {
    _i ??= FreshChatHelper._();
    return _i!;
  }

  Stream<dynamic>? _restoreStream;
  StreamSubscription<dynamic>? _restoreStreamSubsctiption;
  // Stream<dynamic>? _unreadCountStream;
  // StreamSubscription<dynamic>? _onMessageCountUpdate;
  Stream<dynamic>? _notificationInterceptStream;
  StreamSubscription<dynamic>? _onNotificationIntercept;
  bool _isFreshChatEnabled = false;
  bool _initializedFreshChat = false;

  void dispose() {
    _isFreshChatEnabled = false;
    _restoreStreamSubsctiption?.cancel();
    // _onMessageCountUpdate?.cancel();
    _onNotificationIntercept?.cancel();
    _onNotificationIntercept = null;
    // _onMessageCountUpdate = null;
    _restoreStreamSubsctiption = null;
    _notificationInterceptStream = null;
    // _unreadCountStream = null;
    _restoreStream = null;
  }

  enableFreshChatForSubscribedUserOnly() async {
    log("_enableFreshChatForSubscribedUserOnly: $_isFreshChatEnabled");
    if (_isFreshChatEnabled) {
      return;
    }
    _isFreshChatEnabled = true;
    log("_enableFreshChatForSubscribedUserOnly: $_isFreshChatEnabled");
    _initFreshChat();
    await _identifyUser();
    await _notifyRestoreId();
    // _getUnreadMessagesCount();

    if (Platform.isAndroid) {
      _registerFcmToken();
      Freshchat.setNotificationConfig(
        importance: Importance.IMPORTANCE_MAX,
        priority: Priority.PRIORITY_MAX,
        notificationInterceptionEnabled: true,
      );
      _notificationInterceptStream = Freshchat.onNotificationIntercept;
      _onNotificationIntercept = _notificationInterceptStream?.listen((event) {
        log("Freshchat Notification Intercept detected");
        Freshchat.openFreshchatDeeplink(event["url"]);
      });
    }
  }

  void _initFreshChat() {
    log("_initializedFreshChat: $_initializedFreshChat");
    if (_initializedFreshChat) {
      return;
    }
    _initializedFreshChat = true;
    log("_initializedFreshChat: $_initializedFreshChat");

    Freshchat.init(
      ApiKeys.rasselAppId,
      ApiKeys.rasselAppKey,
      ApiKeys.rasselDomain,
      showNotificationBanneriOS: true,
      teamMemberInfoVisible: true,
      errorLogsEnabled: true,
    );
  }

  Future<void> _identifyUser() async {
    // Freshchat.
    // the user id is "External ID"
    final String externalId = (await PrefManager.getId() ?? "");

    /// get saved "Restore ID" Value in secure database
    String? restoreId = await SecureStorage.readRestoreIdByUserId(
      userId: externalId,
    );

    log("Freshchat.identifyUser(externalId: $externalId, restoreId: $restoreId);");
    Freshchat.identifyUser(externalId: externalId, restoreId: restoreId);
  }

  Future<void> _registerFcmToken() async {
    if (Platform.isAndroid) {
      String? token = await FirebaseToken.instance.getToken();
      Freshchat.setPushRegistrationToken(token!);
    }
  }

  Future<void> _notifyRestoreId() async {
    _restoreStream ??= Freshchat.onRestoreIdGenerated;
    _restoreStreamSubsctiption ??= _restoreStream?.listen((event) async {
      log("Restore ID Generated: $event");
      final String externalId = (await PrefManager.getId() ?? "");
      FreshchatUser user = await Freshchat.getUser;
      final String? restoreId = user.getRestoreId();
      if (restoreId != null) {
        await SecureStorage.writeRestoreId(
          restoreId: restoreId,
          userId: externalId,
        );
        log("Freshchat.identifyUser(externalId: $externalId, restoreId: $restoreId);");
        Freshchat.identifyUser(externalId: externalId, restoreId: restoreId);
        log("Restore ID copied: $restoreId");
      }
    });
  }

  void reset() {
    _isFreshChatEnabled = false;
    dispose();
    log("Freshchat.resetUser()");
    Freshchat.resetUser();
  }
}
