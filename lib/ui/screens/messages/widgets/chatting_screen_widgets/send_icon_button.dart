import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/ui/screens/messages/blocs/reply_message_bloc/reply_message_bloc.dart';
import 'package:o7therapy/ui/screens/messages/blocs/send_bird_messages_bloc/sb_messages_bloc.dart';

class SendIconButton extends StatelessWidget {
  const SendIconButton({
    super.key,
    required this.controller,
    required this.scrollController,
  });

  final TextEditingController controller;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: IconButton(
        style: IconButton.styleFrom(
          padding: const EdgeInsets.only(top: 8, bottom: 8, right: 16),
        ),
        onPressed: () {
          debugPrint("send Icon pressed");
          final String message = controller.text.trim();
          final int? parentMessageId =
              ReplyMessageBloc.bloc(context).state.customMessage?.messageId;
          if (message.isNotEmpty) {
            SBMessagesBloc.bloc(context).add(SendMessageEvent(
              message,
              parentMessageId: parentMessageId,
            ));
            ReplyMessageBloc.bloc(context).add(const RemoveReplyMessageEvent());
            controller.clear();
            controller.text == "";
            scrollController.animateTo(
              0.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        },
        icon: SvgPicture.asset(AssPath.sendIcon),
      ),
    );
  }
}
