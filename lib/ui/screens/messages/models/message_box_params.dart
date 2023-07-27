import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/res/const_values.dart';
import 'package:o7therapy/ui/screens/messages/models/messages_models/messages_models.dart';

class MessageBoxParams {
  static const _radiusShape = ConstValues.messageWidgetRadiusShape;
  static const _noRadius = ConstValues.messageWidgetNoRadius;

  final DateTime messageTime;
  final bool isSentByMe;
  final Alignment alignment;
  final CustomMessage customMessage;
  final Color boxColor;
  final Color borderColor;
  final Color textColor;
  final CustomMessageState messageState;
  final Radius bottomLeft;
  final Radius bottomRight;
  final Radius topRight;
  final Radius topLeft;
  const MessageBoxParams({
    this.topRight = _radiusShape,
    this.topLeft = _radiusShape,
    required this.bottomLeft,
    required this.bottomRight,
    required this.messageTime,
    required this.isSentByMe,
    required this.alignment,
    required this.customMessage,
    required this.boxColor,
    required this.borderColor,
    required this.textColor,
    required this.messageState,
  });

  factory MessageBoxParams.get(CustomMessage customMessage) {
    return customMessage.isSentByMe
        ? MessageBoxParams(
            bottomLeft: _radiusShape,
            bottomRight: _noRadius,
            isSentByMe: true,
            alignment: Alignment.topRight,
            customMessage: customMessage,
            boxColor: ConstColors.app,
            borderColor: ConstColors.app,
            textColor: ConstColors.appWhite,
            messageTime: customMessage.createdAt,
            messageState: customMessage.messageState,
          )
        : MessageBoxParams(
            bottomLeft: _noRadius,
            bottomRight: _radiusShape,
            isSentByMe: false,
            borderColor: ConstColors.disabled,
            alignment: Alignment.topLeft,
            customMessage: customMessage,
            boxColor: ConstColors.appWhite,
            textColor: ConstColors.text,
            messageTime: customMessage.createdAt,
            messageState: customMessage.messageState,
          );
  }
}
