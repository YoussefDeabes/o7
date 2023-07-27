import 'dart:io';

import 'package:o7therapy/ui/screens/messages/models/messages_models/messages_models.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

class DocumentMessage extends CustomFileMessage {
  final String? name;
  final int? size;
  final String? extension;

  const DocumentMessage({
    required this.name,
    required this.size,
    required this.extension,
    required super.fileUrl,
    required super.file,
    required super.messageId,
    required super.requestId,
    required super.createdAt,
    required super.isSentByMe,
    required super.messageState,
    required super.parentMsg,
  });

  factory DocumentMessage.getDocumentMessageFromFileMessage(
    FileMessage fileMessage,
    GroupChannel channel,
  ) {
    File? file = fileMessage.localFile;
    return DocumentMessage(
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
      name: fileMessage.name,
      size: fileMessage.size,
      extension: fileMessage.type,
    );
  }
}
