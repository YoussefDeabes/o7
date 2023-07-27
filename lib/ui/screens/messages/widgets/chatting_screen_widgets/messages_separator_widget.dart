import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:o7therapy/res/const_colors.dart';

class MessagesSeparatorWidget extends StatelessWidget {
  final DateTime currentDateTime;
  final DateTime nextDateTime;
  const MessagesSeparatorWidget({
    super.key,
    required this.currentDateTime,
    required this.nextDateTime,
  });

  @override
  Widget build(BuildContext context) {
    if (!_isBothMessagesInSameDays) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(child: Divider(color: ConstColors.textDisabled)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                DateFormat("EEE, dd/MM").format(currentDateTime),
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: ConstColors.textDisabled,
                ),
              ),
            ),
            const Expanded(child: Divider(color: ConstColors.textDisabled)),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  bool get _isBothMessagesInSameDays {
    if (currentDateTime.day == nextDateTime.day &&
        currentDateTime.month == nextDateTime.month &&
        currentDateTime.year == nextDateTime.year) {
      return true;
    } else {
      return false;
    }
  }
}
