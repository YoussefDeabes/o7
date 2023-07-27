import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:o7therapy/ui/screens/messages/models/messages_models/messages_models.dart';
import 'package:o7therapy/util/lang/app_localization.dart';

class MessageTimeAndStatus extends StatelessWidget {
  const MessageTimeAndStatus({
    super.key,
    required this.customMessage,
    required this.textColor,
  });
  final CustomMessage customMessage;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    if (customMessage.messageState == CustomMessageState.none) {
      return const SizedBox.shrink();
    } else {
      return Text(
        "${_getTimeString()} · ${_getStateString(context, customMessage.messageState)}",
        style: TextStyle(
          fontSize: 10.0,
          fontWeight: FontWeight.w400,
          color: textColor,
        ),
      );
    }
  }

  String _getTimeString() {
    return DateFormat('h:mm a').format(customMessage.createdAt);
  }

  String _getStateString(
    BuildContext context,
    CustomMessageState customMessageState,
  ) {
    return AppLocalizations.of(context).translate(customMessageState.langKey);
  }
}
