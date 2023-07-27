import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/widgets/therapist_photo.dart';
import 'package:o7therapy/ui/screens/group_assessment/screen/group_assessment_screen.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

/// the Card of the
/// 1. GroupTherapy
/// 2. Workshops
/// so you need to send the type of data as Generic
// ignore: must_be_immutable
class GroupTherapyAndWorkshopsCard extends BaseStatelessWidget {
  final String imageUrl;
  final String title;
  final String byWhom;
  final int numberOfSpotsAvailable;
  final DateTime startDate, endDate;
  final TimeOfDay startTime, endTime;
  final int price;
  final String currency;
  GroupTherapyAndWorkshopsCard({
    this.currency = "EGP",
    this.price = 0,
    required this.title,
    required this.byWhom,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.numberOfSpotsAvailable,
    Key? key,
  }) : super(key: key);

  @override
  Widget baseBuild(BuildContext context) {
    return Container(
      height: 0.2 * height, // 150/812
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        border: Border.all(color: ConstColors.disabled),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // TODO : the Group Therapy Or Workshops Card was pressed
              Navigator.pushNamed(context, GroupAssessmentScreen.routeName);
              log("the Group Therapy Or Workshops Card was pressed");
            },
            child: Row(
              children: [
                // the Image Of Event
                _getImage(context),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 0.035 * width, vertical: 0.01 * height),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [_getTitle(), _getByWhom()],
                        ),
                        SizedBox(height: 0.003 * height),
                        _getPriceTextWidget(),
                        _getDateTextWidget(),
                        _getTimeTextWidget(),
                        _getSpotsAvailable(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

  /// get Image of the card and cached it in the network
  Widget _getImage(BuildContext context) {
    return TherapistPhoto(imageUrl: imageUrl);
  }

  /// getting the Text Widget title of the workshop or the Group Therapy
  Widget _getTitle() {
    return Text(
      title,
      maxLines: 2,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: ConstColors.text,
        fontSize: 14,
      ),
    );
  }

  /// get By Whom "Therapist" this workshop or Group Therapy created
  Widget _getByWhom() {
    return Text(
      "${translate(LangKeys.by)} $byWhom",
      textAlign: TextAlign.start,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  /// get the date widget of the workshop or group therapy
  Widget _getPriceTextWidget() {
    return Text(
      _getPrice(),
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 12.0,
        color: ConstColors.app,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  /// get the date widget of the workshop or group therapy
  Widget _getDateTextWidget() {
    return Row(
      children: [
        _getSvgIcon(AssPath.calendarIcon),
        SizedBox(width: 0.016 * width),
        Text(
          _getDateString(),
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontSize: 12.0,
              color: ConstColors.textSecondary,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  /// get the Time widget of the workshop or group therapy
  /// in Am or Pm
  Widget _getTimeTextWidget() {
    return Row(
      children: [
        _getSvgIcon(AssPath.clockIcon),
        // Image.asset(AssPath.timerIcon, width: 0.04 * width),
        SizedBox(width: 0.016 * width),
        SizedBox(
          width: 0.4 * width,
          child: Text(
            _getTimeString(),
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 12.0,
                color: ConstColors.textSecondary,
                fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  /// getting the available spots
  Widget _getSpotsAvailable() {
    return Row(
      children: [
        _getSvgIcon(AssPath.peopleIcon),
        // Image.asset(AssPath.peopleIcon, width: 0.04 * width),
        SizedBox(width: 0.016 * width),
        SizedBox(
          width: 0.4 * width,
          child: Text(
            "$numberOfSpotsAvailable ${translate(LangKeys.spotsAvailable)} ",
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 11.0,
                color: ConstColors.textSecondary,
                fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  /// get Svg Icon
  Widget _getSvgIcon(String assetPath) {
    return SvgPicture.asset(assetPath, width: 0.04 * width);
  }
///////////////////////////////////////////////////////////
/////////////////// Helper methods ////////////////////////
///////////////////////////////////////////////////////////

  /// get the date of Group Therapy or Workshop in String
  String _getDateString() {
    if (startDate.month != endDate.month) {
      // same year not Month . 31 dec - 25 jan, 2023
      String startDateString = DateFormat("d MMM").format(startDate);
      String endDateString = DateFormat("d MMM").format(endDate);
      return "$startDateString - $endDateString";
    } else {
      if (startDate.day != endDate.day) {
        // same year Same Month not same day . 31 - 25 jan, 2023
        String startDateString = DateFormat("d").format(startDate);
        String endDateString = DateFormat("d MMM").format(endDate);
        return "$startDateString - $endDateString";
      } else {
        // Same year Same Month Same day . 10 jan, 2023
        return DateFormat("d MMM").format(endDate);
      }
    }
  }

  String _getTimeString() {
    String startTimeString =
        "${startTime.hourOfPeriod}:${startTime.minute.toString().padLeft(2, "0")} ${startTime.period.name}";

    String endTimeString =
        "${endTime.hourOfPeriod}:${endTime.minute.toString().padLeft(2, "0")} ${endTime.period.name}";

    return "$startTimeString - $endTimeString";
  }

  /// get price of the group therapy
  String _getPrice() {
    // String price = price.toString();
    // String currency = currency ?? "";
    return "$price ${translateCurrency(currency)} ";
  }
}
