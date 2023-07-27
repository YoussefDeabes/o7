import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';

class ContactTherapistNumberOfMessages extends StatelessWidget {
  final int? noOfMessage;
  const ContactTherapistNumberOfMessages({
    super.key,
    required this.noOfMessage,
  });

  @override
  Widget build(BuildContext context) {
    return noOfMessage == 0
        ? const SizedBox.shrink()
        : Container(
            height: 16,
            width: 16,
            decoration: BoxDecoration(
              color: ConstColors.accentColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: FittedBox(
                child: Text(
                  noOfMessage.toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: ConstColors.app,
                  ),
                ),
              ),
            ),
          );
  }
}
