import 'package:flutter/material.dart';
import 'package:o7therapy/ui/screens/messages/models/messages_models/text_message.dart';
import 'package:o7therapy/ui/screens/messages/widgets/chatting_screen_widgets/messages_widget/message_time_and_status.dart';

class TextMessageWidget extends StatelessWidget {
  const TextMessageWidget({
    super.key,
    required this.textMessage,
    required this.textColor,
    required this.messageTimeAndStatusWidget,
  });
  final TextMessage textMessage;
  final MessageTimeAndStatus messageTimeAndStatusWidget;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _TextMessage(
            msg: textMessage.message,
            textColor: textColor,
          ),
          messageTimeAndStatusWidget
        ],
      ),
    );
  }
}

class _TextMessage extends StatelessWidget {
  const _TextMessage({
    Key? key,
    required this.msg,
    required this.textColor,
  }) : super(key: key);
  final String msg;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.4),
      child: Text(
        msg,
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          color: textColor,
        ),
      ),
    );
  }
}
