import 'dart:developer';
import 'dart:io';

import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/api/base/base_api_manager.dart';
import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/models/sendBird/chat_contacts/chat_contacts_wrapper.dart';
import 'package:o7therapy/api/models/sendBird/unread_count.dart';
import 'package:o7therapy/api/send_bird_constants.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/ui/screens/messages/blocs/send_bird_channels_bloc/channels_source/sb_channels_from_backend.dart';
import 'package:o7therapy/ui/screens/messages/models/contact_item.dart';
import 'package:o7therapy/ui/screens/messages/models/contact_item_builder_from_back_end.dart';
import 'package:o7therapy/ui/screens/messages/models/messages_models/messages_models.dart';
import 'package:o7therapy/ui/screens/messages/models/load_messages_params.dart';
import 'package:o7therapy/util/general.dart';
import 'package:o7therapy/util/notifications/firebase_token.dart';
import 'package:sendbird_sdk/constant/contants.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';
import 'package:dio/dio.dart' as dio;

/// 1- init sendBird
/// 2- create a connection for specific user
/// 3- get the existing channels if exist
/// 4- get messages associated with the channels
class SendBirdManager with ChannelEventHandler {
  /// make it as singleton
  SendBirdManager._();
  static final SendBirdManager _instance = SendBirdManager._();
  factory SendBirdManager() => _instance;

  /// number of message will get by each call
  static const int _previousResultSize = 20;

  static late final SendbirdSdk _sendBirdSdk;
  static late User? _user;
  static GroupChannelListQuery query = GroupChannelListQuery();
  static SendbirdSdk get sendBirdSdk => _sendBirdSdk;
  static DateTime? _lastMarkAsReadDebounceTime;

  /// get this [_userId] form Shared Pref while connect
  static late String? _userId;

  /// init when user opens the app
  /// when the SBChannelsBloc is called
  static void init() {
    log("init Send Bird");
    _sendBirdSdk = SendbirdSdk(
      appId: SendBirdConstants.sendBirdApplicationID,
      apiToken: SendBirdConstants.sendBirdApiToken,
      options: Options(
        connectionTimeout: 6500,
        authenticationTimeout: 300,
        fileTransferTimeout: 100,
        websocketTimeout: 300,
      ),
    );
    _setLogLevel();
  }

  /// The USER_ID below should be unique to your SendBird application.
  /// first we get the user id form shared pref >> we saved user id when user logged in.. this id is comes from back-end
  /// used this id to connect to sendBird
  static Future<void> connect({
    required Function() onSuccess,
    required Function({String? msg}) onFail,
  }) async {
    try {
      _setLogLevel();
      log("trying to connect user to SendBird:");
      _userId = await PrefManager.getId();
      if (_userId != null) {
        _user = await _sendBirdSdk.connect(_userId!);
        log("connected user name: ${_user?.nickname} && then enable notifications ");
        // await _pushNotificationForSendBird();
        onSuccess();
      } else {
        onFail(msg: "UserID is not Exist!");
      }
    } on SBError catch (e) {
      onFail(msg: e.message);
      log('_sendBirdSdk connect: ERROR: $e');
    } catch (e) {
      log('_sendBirdSdk connect: ERROR: $e');
      onFail();
    }
  }

  static Future<void> _checkConnection() async {
    try {
      final bool isCurrentUserEqualNull = sendBirdSdk.currentUser == null;
      final bool isCurrentUserIdNotTheSameWithStoredId =
          sendBirdSdk.currentUser?.userId != _userId;
      final ConnectionState connectionState = sendBirdSdk.getConnectionState();
      if (connectionState != ConnectionState.open) {
        final bool isReconnected = sendBirdSdk.reconnect();
        // log("$isReconnected");
        // if (!isReconnected) {
        //   throw "Session Expire";
        // }
      }
      if (isCurrentUserIdNotTheSameWithStoredId) {
        await connect(
          onSuccess: () {},
          onFail: ({String? msg}) {
            throw Exception(msg);
          },
        );
      }
      if (isCurrentUserEqualNull) {
        sendBirdSdk.reconnect();
      }
      return;
    } on SBError {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  ///  you may retrieve empty channels in the result.
  /// this endpoint call the backend
  static Future<void> getExistingChannelsFromBackEnd({
    required Function(List<ContactItem> contacts, bool hasNext) onSuccess,
    required Function({String? msg}) onFail,
    required bool reload,
  }) async {
    try {
      await _checkConnection();
      await BaseApi.updateHeader();
      final response = await BaseApi.dio.get(ApiKeys.getChatContactsUrl);
      final ChatContactsWrapper wrapper =
          ChatContactsWrapper.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        List<ContactItem> newContacts = [];
        if (wrapper.data?.list != null) {
          for (final ListElement e in wrapper.data!.list!) {
            if (e.channelUrl != null) {
              ContactItemBuilderFromBackEnd contactItemBuilder =
                  ContactItemBuilderFromBackEnd(
                element: e,
              );
              newContacts.add(contactItemBuilder.getContactItem());
            }
          }
        }

        onSuccess(newContacts, wrapper.data?.hasMore ?? false);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        onFail(msg: details.customErrorMessage);
      }
    } catch (onError) {
      onFail(msg: NetworkExceptions.getDioException(onError).errorMsg);
    }
  }

  /// get the channels from send bird
  static Future<void> getExistingChannelsFromSendBird({
    required Function(List<GroupChannel> groupChannel, bool hasNext) onSuccess,
    required Function({String? msg}) onFail,
    required int limit,
    required bool reload,
  }) async {
    try {
      await _checkConnection();
      if (reload) {
        query = GroupChannelListQuery();
      }
      if (_userId != null) {
        query
          ..userIdsIncludeIn = [_userId!]
          ..includeEmptyChannel = true
          ..order = GroupChannelListOrder.latestLastMessage
          ..limit = limit;
        final groupChannel = await query.loadNext();
        onSuccess(groupChannel, query.hasNext);
      } else {
        onFail(msg: "Invalid User Id");
      }
    } on SBError catch (e) {
      onFail(msg: e.message);
    } catch (e) {
      onFail();
    }
  }

  static Future<void> loadMessagesWithTimeStamp({
    required Function(List<CustomMessage> customMessages, bool hasNext)
        onSuccess,
    required Function({String? msg}) onFail,
    required GroupChannel groupChannel,
    required LoadMessagesParams loadMessagesParams,
  }) async {
    try {
      await _checkConnection();
      final bool reload = loadMessagesParams.reload;
      final DateTime? timeStamp = loadMessagesParams.timeStamp;
      final ts = reload
          ? DateTime.now().millisecondsSinceEpoch
          : timeStamp?.millisecondsSinceEpoch ??
              DateTime.now().millisecondsSinceEpoch;

      final params = MessageListParams()
        ..replyType = ReplyType.all
        ..isInclusive = false
        ..includeThreadInfo = true
        ..reverse = true
        ..previousResultSize = _previousResultSize
        ..includeParentMessageInfo = true;

      final messages = await groupChannel.getMessagesByTimestamp(ts, params);
      final List<CustomMessage> customMessage =
          messages.map((BaseMessage baseMessage) {
        return CustomMessage.getCustomMessageFromBaseMessage(
          baseMessage,
          groupChannel,
        );
      }).toList();
      onSuccess(customMessage, messages.length == _previousResultSize);
    } on SBError catch (e) {
      onFail(msg: e.message);
    } catch (e) {
      onFail();
    }
  }

  static Future<GroupChannel> getCurrentGroupChannelByChannelUrl(
    String channelUrl,
  ) async {
    try {
      return GroupChannel.getChannel(channelUrl);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> _pushNotificationForSendBird() async {
    try {
      await sendBirdSdk.setPushTemplate(sbPushTemplateDefault);
      String? token = await _getToken();
      PushTokenType pushTokenType = _getPushTokenType;
      if (token != null) {
        await sendBirdSdk.registerPushToken(
          type: pushTokenType,
          token: token,
          unique: true,
          alwaysPush: true,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> setNotification(bool value, GroupChannel channel) async {
    try {
      final option = value
          ? GroupChannelPushTriggerOption.all
          : GroupChannelPushTriggerOption.off;
      await channel.setMyPushTriggerOption(option);
    } catch (e) {
      //e
    }
  }

  /// when user logout or session expire we need to disConnect from send bird
  static void logout() async {
    try {
      SBChannelsFromBackend.loadedExistingSBChannelsState = null;
      String? token = await _getToken();
      PushTokenType pushTokenType = _getPushTokenType;
      if (token != null) {
        await sendBirdSdk.unregisterPushToken(
          type: pushTokenType,
          token: token,
        );
      }
      sendBirdSdk.disconnect();
    } catch (e) {
      log("$e");
    }
  }

  static Future<void> getUnreadChannelCountApi({
    required void Function(UnreadCountModel) success,
    required void Function(NetworkExceptions) fail,
  }) async {
    try {
      await _checkConnection();
      await BaseApi.updateHeader();
      final String url = SendBirdConstants.getUnreadChannelCountUrl(_userId!);
      final response = await BaseApi.dio.get(
        url,
        options: dio.Options(headers: {
          SendBirdConstants.sendBirdApiTokenKey:
              SendBirdConstants.sendBirdApiToken,
        }),
      );
      UnreadCountModel wrapper = UnreadCountModel.fromJson(response.data);
      success(wrapper);
    } catch (onError) {
      fail(NetworkExceptions.getDioException(onError));
    }
  }

  static Future<void> markAsReadDebounce(GroupChannel channel) async {
    try {
      // the duration is used to solve this issue
      // Unhandled Exception: Instance of 'MarkAsReadRateLimitExceededError'
      // if the difference between MarkAsReadRateLimitExceededError and now more than 3 seconds
      // then mark markAsRead
      // else don't markAsRead
      final DateTime now = DateTime.now();
      if (_lastMarkAsReadDebounceTime == null ||
          now.difference(_lastMarkAsReadDebounceTime ?? now) >
              const Duration(seconds: 3)) {
        _lastMarkAsReadDebounceTime = now;
        await _checkConnection();
        await channel.markAsRead();
      }
    } catch (e) {
      rethrow;
    }
  }

  static void _setLogLevel() {
    _sendBirdSdk.setLogLevel(isDebugMode() ? LogLevel.error : LogLevel.none);
  }

  static Future<String?> _getToken() async => Platform.isAndroid
      ? FirebaseToken.instance.getToken()
      : FirebaseToken.instance.getAPNSToken();

  static PushTokenType get _getPushTokenType => Platform.isAndroid
      ? PushTokenType.fcm
      : Platform.isIOS
          ? PushTokenType.apns
          : PushTokenType.none;
}
