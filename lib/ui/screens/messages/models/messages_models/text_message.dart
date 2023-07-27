import 'package:o7therapy/ui/screens/messages/models/messages_models/custom_message.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

class TextMessage extends CustomMessage {
  final String message;

  const TextMessage({
    required super.messageId,
    required super.requestId,
    required super.createdAt,
    required super.isSentByMe,
    required this.message,
    required super.messageState,
    required super.parentMsg,
  });

  factory TextMessage.getTextMessageFromUserMessage(
    BaseMessage baseMessage,
    GroupChannel channel,
  ) {
    return TextMessage(
      parentMsg: baseMessage.parentMessage != null
          ? CustomMessage.getCustomMessageFromBaseMessage(
              baseMessage.parentMessage!,
              channel,
            )
          : null,
      messageId: baseMessage.messageId,
      requestId: baseMessage.requestId,
      message: baseMessage.message,
      messageState: CustomMessage.getMessageState(baseMessage, channel),
      isSentByMe: baseMessage.sender?.isCurrentUser ?? false,
      createdAt: CustomMessage.getSentTime(baseMessage.createdAt),
    );
  }

  @override
  String toString() {
    return 'ChatMessage(message: $message, messageState: $messageState, isSentByMe: $isSentByMe, createdAt: $createdAt, messageId: $messageId)';
  }

  TextMessage copyWith({
    String? message,
    CustomMessageState? messageState,
    bool? isSentByMe,
    DateTime? createdAt,
    String? requestId,
    int? messageId,
    String? senderName,
    CustomMessage? parentMsg,
  }) {
    return TextMessage(
      parentMsg: parentMsg ?? this.parentMsg,
      message: message ?? this.message,
      messageState: messageState ?? this.messageState,
      isSentByMe: isSentByMe ?? this.isSentByMe,
      createdAt: createdAt ?? this.createdAt,
      requestId: requestId ?? this.requestId,
      messageId: messageId ?? this.messageId,
    );
  }
}
