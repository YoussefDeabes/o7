import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class ContactTherapistLastMessageTime extends BaseStatelessWidget {
  final DateTime? lastMessageDateTime;
  ContactTherapistLastMessageTime({
    super.key,
    required this.lastMessageDateTime,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return Text(
      lastMessageDateTime == null
          ? ""
          : _getTherapistLastMessageString(lastMessageDateTime!),
      style: const TextStyle(
        color: ConstColors.textSecondary,
        fontWeight: FontWeight.w400,
        fontSize: 11,
      ),
    );
  }

  ///
  /// Helper Methods
  ///

  String _getTherapistLastMessageString(DateTime dateTime) {
    String dayAndMonth = DateFormat("d MMMM").format(dateTime);
    if (_calculateDifferenceInDays(dateTime) == -1) {
      dayAndMonth = translate(LangKeys.yesterday);
    } else if (_calculateDifferenceInDays(dateTime) == 0) {
      dayAndMonth = translate(LangKeys.today);
    }
    return dayAndMonth;
  }

  /// Yesterday : calculateDifference(date) == -1.
  /// Today : calculateDifference(date) == 0.
  /// Tomorrow : calculateDifference(date) == 1.
  int _calculateDifferenceInDays(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }
}
