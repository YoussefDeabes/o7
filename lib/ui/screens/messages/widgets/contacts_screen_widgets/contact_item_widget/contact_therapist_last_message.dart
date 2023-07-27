import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';

class ContactTherapistLastMessage extends StatelessWidget {
  const ContactTherapistLastMessage({
    Key? key,
    required this.width,
    required this.lastMessage,
  }) : super(key: key);

  final double width;
  final String lastMessage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width * 0.7,
      child: Text(
        lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: ConstColors.textSecondary,
        ),
      ),
    );
  }
}
