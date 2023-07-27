import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:o7therapy/ui/screens/messages/blocs/current_opened_chat_bloc/current_opened_chat_bloc.dart';
import 'package:o7therapy/ui/screens/notifications/model/send_bird_message_model.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/notifications/widgets/o7_notification.dart';
import 'package:overlay_support/overlay_support.dart';

/// Opened App Message _firebaseMessagingOnMessageHandler
Future<void> firebaseMessagingOnMessageHandler(RemoteMessage message) async {
  log("data");
  log(message.data.toString());
  log("notification?.body");
  log(message.notification?.body ?? " ");
  log("notification?.title");
  log(message.notification?.title ?? "");

  if (await (_checkIsFreshchatNotification(message))) {
    return;
  } else if (_checkSendBirdMessage(message)) {
    return;
  }
  if (message.notification != null) {
    operateOnMessage(
      message.notification!.title,
      message.notification!.body,
      data: message.data,
    );
  }
}

bool _checkSendBirdMessage(RemoteMessage message) {
  if (message.data["sendbird"] == null) {
    return false;
  }
  if (!SendBirdMessageModel.isSendBirdMessageModel(message.data)) {
    return false;
  }
  try {
    SendBirdMessageModel sendBirdMessageModel =
        SendBirdMessageModel.fromMap(message.data);
    showOverlayNotification(
      (context) {
        return BlocBuilder<CurrentOpenedChatBloc, CurrentOpenedChatState>(
          buildWhen: (previous, current) {
            return current.currentOpenChannelUrl !=
                sendBirdMessageModel.sendBird.channel.channelUrl;
          },
          builder: (context, state) {
            if (state.currentOpenChannelUrl ==
                sendBirdMessageModel.sendBird.channel.channelUrl) {
              return const SizedBox.shrink();
            }
            return O7Notification(
              title:
                  AppLocalizations.of(context).translate(LangKeys.newMessage),
              body: sendBirdMessageModel.sendBird.message,
              key: UniqueKey(),
            );
          },
        );
      },
      duration: const Duration(seconds: 4),
    );
    return true;
  } catch (e) {
    debugPrint("Not A SendBird Message");
    return false;
  }
}

operateOnMessage(String? title, String? body, {Map? data}) async {
  log('Operating Message:\n $title $body');
  showOverlayNotification(
    (context) {
      return O7Notification(
        title: title,
        body: body,
        data: data,
        key: UniqueKey(),
      );
    },
    duration: const Duration(seconds: 4),
  );
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
