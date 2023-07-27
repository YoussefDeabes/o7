import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/res/const_values.dart';
import 'package:o7therapy/ui/screens/messages/blocs/reply_message_bloc/reply_message_bloc.dart';
import 'package:o7therapy/ui/screens/messages/models/messages_models/messages_models.dart';

class MessageReplyPreview extends StatelessWidget {
  final CustomMessage customMessage;
  final bool isClearReplyIconHidden;
  const MessageReplyPreview({
    super.key,
    required this.customMessage,
    this.isClearReplyIconHidden = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      decoration: const BoxDecoration(
        color: ConstColors.appWhite,
        borderRadius: BorderRadius.only(
          topLeft: ConstValues.messageWidgetRadiusShape,
          topRight: ConstValues.messageWidgetRadiusShape,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: const BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.only(
            topLeft: ConstValues.messageWidgetRadiusShape,
            topRight: ConstValues.messageWidgetRadiusShape,
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 4,
                decoration: const BoxDecoration(
                  color: ConstColors.app,
                  borderRadius: BorderRadius.only(
                      topLeft: ConstValues.messageWidgetRadiusShape,
                      topRight: ConstValues.messageWidgetRadiusShape),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            customMessage.isSentByMe ? "YOu" : "Send To Me",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        isClearReplyIconHidden
                            ? const SizedBox.shrink()
                            : GestureDetector(
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                ),
                                onTap: () {
                                  ReplyMessageBloc.bloc(context)
                                      .add(const RemoveReplyMessageEvent());
                                },
                              ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildReplyMessage(customMessage),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReplyMessage(CustomMessage customMessage) {
    if (customMessage is TextMessage) {
      return _getTextReplyMessageWidget(customMessage);
    } else if (customMessage is AudioMessage) {
      return _getAudioPlayerReplyMessageWidget(customMessage);
    } else if (customMessage is ImageMessage) {
      return _getReplyImageMessageWidget(customMessage);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _getTextReplyMessageWidget(TextMessage textMessage) {
    return Text(
      textMessage.message,
      maxLines: 3,
      style: const TextStyle(color: Colors.black54),
    );
  }

  Widget _getAudioPlayerReplyMessageWidget(AudioMessage textMessage) {
    return const Text(
      "Audio",
      maxLines: 3,
      style: TextStyle(color: Colors.black54),
    );
  }

  Widget _getReplyImageMessageWidget(customMessage) {
    return const Text(
      "Image",
      maxLines: 3,
      style: TextStyle(color: Colors.black54),
    );
  }
}
