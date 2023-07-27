import 'dart:developer';
import 'dart:io';

import 'package:just_audio/just_audio.dart';
import 'package:o7therapy/ui/screens/messages/models/messages_models/custom_file_message.dart';
import 'package:o7therapy/ui/screens/messages/models/messages_models/custom_message.dart';
import 'package:sendbird_sdk/core/channel/group/group_channel.dart';
import 'package:sendbird_sdk/core/message/file_message.dart';

class AudioMessage extends CustomFileMessage {
  final AudioSource audioSource;

  const AudioMessage({
    required this.audioSource,
    required super.fileUrl,
    required super.file,
    required super.messageId,
    required super.requestId,
    required super.createdAt,
    required super.isSentByMe,
    required super.messageState,
    required super.parentMsg,
  });

  factory AudioMessage.getAudioMessageFromFileMessage(
    FileMessage fileMessage,
    GroupChannel channel,
  ) {
    File? file = fileMessage.localFile;

    Uri? audioUri = file?.uri;
    audioUri ??= Uri.parse(fileMessage.url);

    log("audioUri: $audioUri ");
    return AudioMessage(
      parentMsg: fileMessage.parentMessage != null
          ? CustomMessage.getCustomMessageFromBaseMessage(
              fileMessage.parentMessage!,
              channel,
            )
          : null,
      messageId: fileMessage.messageId,
      requestId: fileMessage.requestId,
      audioSource: AudioSource.uri(audioUri),
      file: file,
      fileUrl: fileMessage.secureUrl ?? fileMessage.url,
      messageState: CustomMessage.getMessageState(fileMessage, channel),
      isSentByMe: fileMessage.sender?.isCurrentUser ?? false,
      createdAt: CustomMessage.getSentTime(fileMessage.createdAt),
    );
  }
}
