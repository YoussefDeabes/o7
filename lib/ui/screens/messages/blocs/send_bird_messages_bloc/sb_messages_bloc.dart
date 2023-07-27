import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/ui/screens/messages/models/messages_models/messages_models.dart';
import 'package:o7therapy/ui/screens/messages/models/load_messages_params.dart';
import 'package:o7therapy/api/send_bird_manager.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';
import 'package:path/path.dart' as p;

part 'sb_messages_event.dart';
part 'sb_messages_state.dart';

class SBMessagesBloc extends Bloc<SBMessagesEvent, SBMessagesState>
    with ChannelEventHandler, ConnectionEventHandler {
  static const String _channelListener = "channel_listener";
  static const String _connectionListener = "connection_listener";
  List<CustomMessage> _messages = [];
  bool _hasNext = false;
  late GroupChannel channel;

  SBMessagesBloc() : super(const InitialSBMessagesState()) {
    on<UpdateGroupChannelSBMessagesEvent>(_onUpdateGroupChannel);
    on<SendMessageEvent>(_onSendMessageEvent);
    on<SendFileMessageEvent>(_onSendFileMessageEvent);
    on<LoadAllPreviousMessagesEvent>(_onLoadAllPreviousMessagesEvent);
    on<LoadMoreMessagesEvent>(_onLoadMoreMessagesEvent);
    on<UpdateLoadedMessagesStateEvent>(_onMessageReceivedEvent);
  }

  @override
  Future<void> close() {
    SendBirdManager.sendBirdSdk
        .removeConnectionEventHandler(_connectionListener);
    SendBirdManager.sendBirdSdk.removeChannelEventHandler(_channelListener);
    return super.close();
  }

  static SBMessagesBloc bloc(BuildContext context) =>
      context.read<SBMessagesBloc>();

  Future<void> _onUpdateGroupChannel(
    UpdateGroupChannelSBMessagesEvent event,
    emit,
  ) async {
    channel = event.groupChannel;
    _messages = [];
    _hasNext = false;
    SendBirdManager.sendBirdSdk
        .addConnectionEventHandler(_connectionListener, this);
    SendBirdManager.sendBirdSdk.addChannelEventHandler(_channelListener, this);
    await SendBirdManager.setNotification(true, event.groupChannel);
  }

  void _onSendFileMessageEvent(SendFileMessageEvent event, emit) async {
    final params = FileMessageParams.withFile(
      event.file,
      name: p.basename(event.file.path),
    )
      ..customType = event.customMessageType.name
      ..replyToChannel = true
      ..parentMessageId = event.parentMessageId
      ..pushOption = PushNotificationDeliveryOption.normal;

    final preMessage = channel.sendFileMessage(
      params,
      onCompleted: (FileMessage msg, Error? error) async {
        if (error != null) {
          await _messageError(msg);
        }
        final index = _messages
            .indexWhere((element) => element.requestId == msg.requestId);
        if (index != -1) _messages.removeAt(index);

        _messages = [
          CustomFileMessage.getCustomFileMessageFromFileMessage(
            msg,
            channel,
            event.customMessageType,
          ),
          ..._messages
        ];

        _messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        _markChannelAsRead();

        add(const UpdateLoadedMessagesStateEvent());
      },
      progress: (sentBytes, totalBytes) {
        debugPrint((sentBytes / totalBytes * 100).round().toString());
      },
    );

    _messages = [
      CustomFileMessage.getCustomFileMessageFromFileMessage(
        preMessage,
        channel,
        event.customMessageType,
      ),
      ..._messages
    ];
    emit(LoadedSBMessagesState(
      chatMessages: _messages,
      hasNext: _hasNext,
    ));
  }

  _onLoadAllPreviousMessagesEvent(
    LoadAllPreviousMessagesEvent event,
    emit,
  ) async {
    emit(const LoadingSBMessagesState());
    SBMessagesState? state;
    try {
      await SendBirdManager.loadMessagesWithTimeStamp(
        loadMessagesParams: event.loadMessagesParams,
        groupChannel: channel,
        onSuccess: (List<CustomMessage> previousChatMessage, bool hasNext) {
          _hasNext = hasNext;

          /// if the messages for the first time
          /// no next messages
          /// then: that is the first messages between the therapist and client
          if (previousChatMessage.isEmpty && !hasNext) {
            state = const EmptyPreviousSBMessagesState();
          } else {
            _messages = event.loadMessagesParams.reload
                ? previousChatMessage
                : _messages + previousChatMessage;
            state = LoadedSBMessagesState(
              chatMessages: _messages,
              hasNext: hasNext,
            );
          }
          _markChannelAsRead();
        },
        onFail: ({String? msg}) {
          state = ExceptionSBMessagesState(message: msg);
        },
      );
    } catch (e) {
      state = const ExceptionSBMessagesState();
    }
    return emit(state!);
  }

  _onSendMessageEvent(SendMessageEvent event, emit) async {
    String message = event.message;
    final params = UserMessageParams(
      message: message,
    )
      ..pushOption = PushNotificationDeliveryOption.normal
      ..targetLanguages = _getSupportLocalesLanguages
      ..replyToChannel = true
      ..parentMessageId = event.parentMessageId;

    final preMessage = channel.sendUserMessage(
      params,
      onCompleted: (msg, error) async {
        if (error != null) {
          await _messageError(msg);
        } else {
          final int index = _messages.indexWhere(
            (element) => element.requestId == msg.requestId,
          );
          if (index != -1) {
            _messages.removeAt(index);
          }
          _messages = [
            TextMessage.getTextMessageFromUserMessage(msg, channel),
            ..._messages
          ];
          _messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          _markChannelAsRead();

          add(const UpdateLoadedMessagesStateEvent());
        }
      },
    );
    _messages = [
      TextMessage.getTextMessageFromUserMessage(preMessage, channel)
          .copyWith(isSentByMe: true),
      ..._messages
    ];
    emit(LoadedSBMessagesState(
      chatMessages: _messages,
      hasNext: _hasNext,
    ));
  }

  @override
  void onMessageReceived(BaseChannel channel, BaseMessage message) {
    if (channel.channelUrl != this.channel.channelUrl) return;
    CustomMessage chatMessage = CustomMessage.getCustomMessageFromBaseMessage(
      message,
      channel as GroupChannel,
    );
    final index =
        _messages.indexWhere((e) => e.messageId == chatMessage.messageId);
    if (index != -1 && _messages.isNotEmpty) {
      _messages.removeAt(index);
      _messages[index] = chatMessage;
    } else {
      _messages.insert(0, chatMessage);
    }
    _markChannelAsRead();
    add(const UpdateLoadedMessagesStateEvent());
    super.onMessageReceived(channel, message);
  }

  _onMessageReceivedEvent(UpdateLoadedMessagesStateEvent event, emit) async {
    emit(const LoadingSBMessagesState());
    emit(LoadedSBMessagesState(
      chatMessages: [..._messages],
      hasNext: _hasNext,
    ));
  }

  _onLoadMoreMessagesEvent(LoadMoreMessagesEvent event, emit) async {
    SBMessagesState? state;
    try {
      await SendBirdManager.loadMessagesWithTimeStamp(
        loadMessagesParams: event.loadMessagesParams,
        groupChannel: channel,
        onSuccess: (List<CustomMessage> moreCustomMessage, bool hasNext) {
          _messages = [..._messages, ...moreCustomMessage];
          _hasNext = hasNext;
          state = LoadedSBMessagesState(
            chatMessages: _messages,
            hasNext: hasNext,
          );
        },
        onFail: ({String? msg}) {
          state = ExceptionSBMessagesState(message: msg);
        },
      );
    } catch (e) {
      state = const ExceptionSBMessagesState();
    }

    return emit(state!);
  }

  @override
  void onMessageUpdated(BaseChannel channel, BaseMessage message) {
    if (channel.channelUrl != this.channel.channelUrl) return;
    CustomMessage chatMessage = CustomMessage.getCustomMessageFromBaseMessage(
      message,
      channel as GroupChannel,
    );
    final index = _messages.indexWhere((e) => e.messageId == message.messageId);
    _messages = [..._messages];
    if (index != -1 && _messages.isNotEmpty) {
      _messages.removeAt(index);
      _messages[index] = chatMessage;
    } else {
      _messages.insert(0, chatMessage);
    }

    _markChannelAsRead();
    add(const UpdateLoadedMessagesStateEvent());
  }

  @override
  void onMessageDeleted(BaseChannel channel, int messageId) {
    if (channel.channelUrl != this.channel.channelUrl) return;
    _messages.removeWhere((e) => e.messageId == messageId);
    add(const UpdateLoadedMessagesStateEvent());
  }

  @override
  void onReadReceiptUpdated(GroupChannel channel) async {
    //A user has read a specific unread message in a group channel.
    if (channel.channelUrl != this.channel.channelUrl) return;
    log("onReadReceiptUpdated");
    for (var i = 0; i < _messages.length; i++) {
      final customMessage = _messages[i];
      if (customMessage.messageState != CustomMessageState.read) {
        await _updateMessageStatus(customMessage: customMessage, index: i);
      } else {
        break;
      }
    }
    add(const UpdateLoadedMessagesStateEvent());
  }

  Future<void> _updateMessageStatus({
    required CustomMessage customMessage,
    required int index,
  }) async {
    final params = MessageRetrievalParams(
      messageId: customMessage.messageId,
      channelType: ChannelType.group,
      channelUrl: channel.channelUrl,
    )
      ..includeReplies = true
      ..includeParentMessageInfo = true
      ..replyType = ReplyType.all
      ..includeThreadInfo = true;

    final BaseMessage message = await BaseMessage.getMessage(params);
    _messages.removeAt(index);
    _messages.insert(
        index, CustomMessage.getCustomMessageFromBaseMessage(message, channel));
  }

  @override
  void onDeliveryReceiptUpdated(GroupChannel channel) {
    if (channel.channelUrl != this.channel.channelUrl) return;
    add(const UpdateLoadedMessagesStateEvent());
  }

  List<String> get _getSupportLocalesLanguages =>
      AppLocalizations.supportLocales
          .map((Locale locale) => locale.languageCode)
          .toList();

  /// if the user open the chatting screen then
  /// call the method mark as read else do nothing
  Future<void> _markChannelAsRead() async {
    log("_isChattingScreenOpen");
    try {
      await SendBirdManager.markAsReadDebounce(channel);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _messageError(BaseMessage msg) async {
    final index =
        _messages.indexWhere((element) => element.requestId == msg.requestId);
    _updateMessageStatus(customMessage: _messages[index], index: index);
    add(const UpdateLoadedMessagesStateEvent());
  }
}
