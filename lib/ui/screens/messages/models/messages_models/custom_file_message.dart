import 'dart:io';

import 'package:o7therapy/ui/screens/messages/models/messages_models/audio_message.dart';
import 'package:o7therapy/ui/screens/messages/models/messages_models/custom_message.dart';
import 'package:o7therapy/ui/screens/messages/models/messages_models/document_message.dart';
import 'package:o7therapy/ui/screens/messages/models/messages_models/image_message.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

abstract class CustomFileMessage extends CustomMessage {
  final File? file;
  final String fileUrl;

  const CustomFileMessage({
    required this.fileUrl,
    required this.file,
    required super.messageId,
    required super.requestId,
    required super.createdAt,
    required super.isSentByMe,
    required super.messageState,
    required super.parentMsg,
  });

  factory CustomFileMessage.getCustomFileMessageFromFileMessage(
    FileMessage fileMessage,
    GroupChannel channel,
    CustomMessageType messageType,
  ) {
    switch (messageType) {
      case CustomMessageType.audio:
        return AudioMessage.getAudioMessageFromFileMessage(
          fileMessage,
          channel,
        );

      case CustomMessageType.image:
        return ImageMessage.getImageMessageFromFileMessage(
          fileMessage,
          channel,
        );
      case CustomMessageType.document:
        return DocumentMessage.getDocumentMessageFromFileMessage(
          fileMessage,
          channel,
        );
      default:

        /// musth throw an exception
        return ImageMessage(
          parentMsg: fileMessage.parentMessage != null
              ? CustomMessage.getCustomMessageFromBaseMessage(
                  fileMessage.parentMessage!,
                  channel,
                )
              : null,
          messageId: fileMessage.messageId,
          requestId: fileMessage.requestId,
          file: fileMessage.localFile,
          fileUrl: fileMessage.secureUrl ?? fileMessage.url,
          messageState: CustomMessage.getMessageState(fileMessage, channel),
          isSentByMe: fileMessage.sender?.isCurrentUser ?? false,
          createdAt: CustomMessage.getSentTime(fileMessage.createdAt),
        );
    }
  }
}
