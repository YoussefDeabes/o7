import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

import 'package:o7therapy/ui/screens/messages/models/messages_models/custom_file_message.dart';
import 'package:o7therapy/ui/screens/messages/models/messages_models/text_message.dart';

enum CustomMessageState {
  sent(langKey: LangKeys.sent),
  fail(langKey: LangKeys.fail),
  pending(langKey: LangKeys.pending),
  read(langKey: LangKeys.read),
  none(langKey: LangKeys.none);

  const CustomMessageState({required this.langKey});
  final String langKey;
}

enum CustomMessageType { audio, video, image, document, text }

abstract class CustomMessage {
  final CustomMessageState messageState;
  final bool isSentByMe;
  final DateTime createdAt;
  final String? requestId;
  final int messageId;
  final CustomMessage? parentMsg;

  const CustomMessage({
    required this.parentMsg,
    required this.messageState,
    required this.isSentByMe,
    required this.createdAt,
    required this.requestId,
    required this.messageId,
  });

  /// convert the time form baseMessage in millisecond(UTC) to local DateTime
  static DateTime getSentTime(int baseMessageCreatedAtTime) {
    return DateTime.fromMillisecondsSinceEpoch(
      baseMessageCreatedAtTime,
      isUtc: true,
    ).toLocal();
  }

  /// convert form BaseMessage.MessageSendingStatus form sdk
  /// to MessageState enum
  static CustomMessageState getMessageState(
    BaseMessage baseMessage,
    GroupChannel channel,
  ) {
    final isMessageReadByAll = channel.getUnreadMembers(baseMessage).isEmpty;
    if (isMessageReadByAll) {
      return CustomMessageState.read;
    }
    switch (baseMessage.sendingStatus) {
      case MessageSendingStatus.failed:
        return CustomMessageState.fail;
      case MessageSendingStatus.succeeded:
        return CustomMessageState.sent;
      case MessageSendingStatus.pending:
        return CustomMessageState.pending;
      default:
        return CustomMessageState.none;
    }
  }

  factory CustomMessage.getCustomMessageFromBaseMessage(
    BaseMessage baseMessage,
    GroupChannel channel,
  ) {
    if (baseMessage is UserMessage) {
      return TextMessage.getTextMessageFromUserMessage(baseMessage, channel);
    } else if (baseMessage is FileMessage) {
      return CustomFileMessage.getCustomFileMessageFromFileMessage(
        baseMessage,
        channel,
        _getFileType(baseMessage.customType ?? ""),
      );
    } else {
      throw Exception("baseMessage is Not UserMessage or FileMessage");
    }
  }

  static CustomMessageType _getFileType(String customTypeString) {
    try {
      return CustomMessageType.values.firstWhere(
        (type) => type.name == customTypeString,
      );
    } catch (e) {
      return CustomMessageType.text;
    }
  }

  @override
  String toString() {
    return 'CustomMessage(messageState: $messageState, isSentByMe: $isSentByMe, createdAt: $createdAt, requestId: $requestId, messageId: $messageId, parentMsg: $parentMsg)';
  }
}
