import 'dart:io';

import 'package:o7therapy/ui/screens/messages/models/messages_models/custom_file_message.dart';
import 'package:o7therapy/ui/screens/messages/models/messages_models/messages_models.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

class ImageMessage extends CustomFileMessage {
  const ImageMessage({
    required super.fileUrl,
    required super.file,
    required super.messageId,
    required super.requestId,
    required super.createdAt,
    required super.isSentByMe,
    required super.messageState,
    required super.parentMsg,
  });

  factory ImageMessage.getImageMessageFromFileMessage(
    FileMessage fileMessage,
    GroupChannel channel,
  ) {
    File? file = fileMessage.localFile;
    return ImageMessage(
      parentMsg: fileMessage.parentMessage != null
          ? CustomMessage.getCustomMessageFromBaseMessage(
              fileMessage.parentMessage!,
              channel,
            )
          : null,
      messageId: fileMessage.messageId,
      requestId: fileMessage.requestId,
      file: file,
      fileUrl: fileMessage.secureUrl ?? fileMessage.url,
      messageState: CustomMessage.getMessageState(fileMessage, channel),
      isSentByMe: fileMessage.sender?.isCurrentUser ?? false,
      createdAt: CustomMessage.getSentTime(fileMessage.createdAt),
    );
  }
}
