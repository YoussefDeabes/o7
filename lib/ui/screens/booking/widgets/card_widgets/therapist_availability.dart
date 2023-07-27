import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/widgets/card_widgets/svg_card_icon.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class TherapistAvailability extends StatelessWidget {
  final bool? acceptNewClient;
  final String? firstAvailableSlotDate;

  const TherapistAvailability({
    super.key,
    required this.firstAvailableSlotDate,
    required this.acceptNewClient,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgCardIcon(assetPath: getCalenderIcon()),
        SizedBox(width: 0.016 * MediaQuery.of(context).size.width),
        Expanded(
          child: Text(
            getTherapistAvailabilityString(
              AppLocalizations.of(context).translate,
            ),
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            maxLines: 1,
            style: TextStyle(
              fontSize: 13.0,
              color: getTextColor(),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  /// get the calender icon for the availability depend on accept new clients or not available
  String getCalenderIcon() {
    if (_isThereFirstAvailableSlotDate && _isAcceptNewClient) {
      return AssPath.calendarGreenIcon;
    } else {
      return AssPath.calendarGreyIcon;
    }
  }

  Color getTextColor() {
    if (_isThereFirstAvailableSlotDate && _isAcceptNewClient) {
      return ConstColors.secondary;
    } else {
      return ConstColors.textSecondary;
    }
  }

  /// 1. Therapist has [no slots] and [accepts a new client]
  /// The Availability on the card should be “No Available slots”
  /// 2. Therapist has [no slots] and [does not accept a new client]
  /// The Availability on the card should be Not Available
  /// 3. Therapist has [slots] and [does not accept a new client]
  /// The Availability on the card should be Not Accepting New Clients
  String getTherapistAvailabilityString(String Function(String) translate) {
    /// the string form "first_available_slot_date": "20220804130000"
    if (!_isThereFirstAvailableSlotDate && _isAcceptNewClient) {
      // return "No Available slots";
      return translate(LangKeys.noAvailableSlots);
    } else if (!_isThereFirstAvailableSlotDate && !_isAcceptNewClient) {
      // return "Not Available";
      return translate(LangKeys.notAvailable);
    } else if (_isThereFirstAvailableSlotDate && !_isAcceptNewClient) {
      // return "Not Accepting New Clients";
      return translate(LangKeys.notAcceptsNewClients);
    } else {
      final String dateWithT =
          '${firstAvailableSlotDate!.substring(0, 8)}T${firstAvailableSlotDate!.substring(8)}Z';

      DateTime dateTime = DateTime.parse(dateWithT).toLocal();

      final String hours = DateFormat('h').format(dateTime);
      final String minutes = DateFormat('mm').format(dateTime);
      final String amAndPmAbbreviation =
          DateFormat('a').format(dateTime).toLowerCase();

      String dayAndMonth = DateFormat("MMM d,").format(dateTime);
      if (calculateDifferenceInDays(dateTime) == 1) {
        dayAndMonth = translate(LangKeys.tomorrow);
      } else if (calculateDifferenceInDays(dateTime) == 0) {
        dayAndMonth = translate(LangKeys.today);
      }
      return "${translate(LangKeys.available)} $dayAndMonth ${translate(LangKeys.at)} $hours:$minutes $amAndPmAbbreviation";
    }
  }

  /// Yesterday : calculateDifference(date) == -1.
  /// Today : calculateDifference(date) == 0.
  /// Tomorrow : calculateDifference(date) == 1.
  int calculateDifferenceInDays(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  bool get _isThereFirstAvailableSlotDate => firstAvailableSlotDate != null;

  bool get _isAcceptNewClient => acceptNewClient ?? false;
}
