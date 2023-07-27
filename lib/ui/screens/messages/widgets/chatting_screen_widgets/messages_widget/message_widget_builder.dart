import 'package:flutter/material.dart';

import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/messages/blocs/reply_message_bloc/reply_message_bloc.dart';
import 'package:o7therapy/ui/screens/messages/models/message_box_params.dart';
import 'package:o7therapy/ui/screens/messages/models/messages_models/messages_models.dart';
import 'package:o7therapy/ui/screens/messages/widgets/chatting_screen_widgets/message_reply_preview.dart';
import 'package:o7therapy/ui/screens/messages/widgets/chatting_screen_widgets/messages_widget/audio_player_message_widget.dart';
import 'package:o7therapy/ui/screens/messages/widgets/chatting_screen_widgets/messages_widget/document_message_widget.dart';
import 'package:o7therapy/ui/screens/messages/widgets/chatting_screen_widgets/messages_widget/image_message_widget.dart';
import 'package:o7therapy/ui/screens/messages/widgets/chatting_screen_widgets/messages_widget/message_time_and_status.dart';
import 'package:o7therapy/ui/screens/messages/widgets/chatting_screen_widgets/messages_widget/text_message_widget.dart';

class MessageWidgetBuilder extends StatelessWidget {
  const MessageWidgetBuilder({required super.key, required this.customMessage});
  final CustomMessage customMessage;

  @override
  Widget build(BuildContext context) {
    return  _MessageWidget(
        key: super.key,
        messageTimeAndStatusWidget: MessageTimeAndStatus(
          customMessage: customMessage,
          textColor: MessageBoxParams.get(customMessage).textColor,
        ),
        messageBoxParams: MessageBoxParams.get(customMessage),
    );
    //! when activate the
    // return Dismissible(
    //   key: ValueKey(customMessage.messageId),
    //   direction: customMessage.isSentByMe
    //       ? DismissDirection.endToStart
    //       : DismissDirection.startToEnd,
    //   movementDuration: const Duration(milliseconds: 300),
    //   resizeDuration: const Duration(milliseconds: 1000),
    //   behavior: HitTestBehavior.deferToChild,
    //   confirmDismiss: (direction) {
    //     ReplyMessageBloc.bloc(context).add(
    //       AddReplyMessageEvent(customMessage: customMessage),
    //     );
    //     return Future.value(false);
    //   },
    //   background: Align(
    //     alignment: customMessage.isSentByMe
    //         ? AlignmentDirectional.centerEnd
    //         : AlignmentDirectional.centerStart,
    //     child: const Icon(
    //       Icons.reply_outlined,
    //       size: 24,
    //       color: ConstColors.app,
    //     ),
    //   ),
    //   child: _MessageWidget(
    //     messageBoxParams: MessageBoxParams.get(customMessage),
    //   ),
    // );
  }
}

class _MessageWidget extends StatelessWidget {
  final MessageBoxParams messageBoxParams;
  final MessageTimeAndStatus messageTimeAndStatusWidget;
  const _MessageWidget({
    super.key,
    required this.messageBoxParams,
    required this.messageTimeAndStatusWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Align(
        alignment: messageBoxParams.alignment,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          decoration: BoxDecoration(
            color: messageBoxParams.boxColor,
            borderRadius: BorderRadius.only(
              bottomLeft: messageBoxParams.bottomLeft,
              bottomRight: messageBoxParams.bottomRight,
              topRight: messageBoxParams.topRight,
              topLeft: messageBoxParams.topLeft,
            ),
            border: Border.all(color: messageBoxParams.borderColor),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildReplyMessage(messageBoxParams.customMessage.parentMsg),
              _buildMessage(messageBoxParams.customMessage),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessage(CustomMessage customMessage) {
    if (customMessage is TextMessage) {
      return TextMessageWidget(
        messageTimeAndStatusWidget: messageTimeAndStatusWidget,
        textMessage: customMessage,
        textColor: messageBoxParams.textColor,
      );
    } else if (customMessage is AudioMessage) {
      return AudioPlayerMessageWidget(
        audioMessage: customMessage,
        messageTimeAndStatusWidget: messageTimeAndStatusWidget,
      );
    } else if (customMessage is ImageMessage) {
      return ImageMessageWidget(
        alignment: messageBoxParams.alignment,
        messageTimeAndStatusWidget: messageTimeAndStatusWidget,
        imageMessage: customMessage,
      );
    } else if (customMessage is DocumentMessage) {
      return DocumentMessageWidget(
        alignment: messageBoxParams.alignment,
        messageTimeAndStatusWidget: messageTimeAndStatusWidget,
        documentMessage: customMessage,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildReplyMessage(CustomMessage? customMessage) {
    if (customMessage == null) {
      return const SizedBox.shrink();
    } else {
      return MessageReplyPreview(
        customMessage: customMessage,
        isClearReplyIconHidden: true,
      );
    }
  }
}
