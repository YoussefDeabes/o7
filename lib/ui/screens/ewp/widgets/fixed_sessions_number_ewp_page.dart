import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:o7therapy/ui/screens/ewp/models/ewp_view_model.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class FixedSessionsNumberEwpPage extends BaseStatelessWidget {
  final EwpViewModel ewpViewModel;
  FixedSessionsNumberEwpPage({required this.ewpViewModel, super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: height * 0.06),
          // EWP Name
          _getEwpName(),
          const SizedBox(height: 7),

          // Employee Wellness Plan
          _getEwpText(),
          const SizedBox(height: 20),

          // container contain the details of the ewp plan
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 0.025 * height,
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              border: Border.all(color: ConstColors.disabled),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _getRemainingSessions(ewpViewModel.remainingCap!),
                _getEwpDetails(),
                _getProgressBar(),
              ],
            ),
          ),

          const SizedBox(height: 20),
          _getBenefitsPlanWidget(),
          SizedBox(height: 0.07 * height),
        ],
      ),
    );
  }

  ///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

  /// get name of the company responsible of the ewp
  Widget _getEwpName() {
    return Text(
      ewpViewModel.corporateName ?? "",
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: ConstColors.text,
      ),
    );
  }

// get Employee Wellness Plan Fixed Text only
  Widget _getEwpText() {
    return Text(
      translate(LangKeys.employeeWellnessPlan),
      style: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: ConstColors.textSecondary,
      ),
    );
  }

  /// get Remaining Number Of Sessions
  Widget _getRemainingSessions(int numberOfRemainingSessions) {
    return Text(
      numberOfRemainingSessions.translateStringDigits(
        languageCode: appLocal.locale.languageCode,
      ),
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 40,
        color: ConstColors.accentColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// get details about total session and remaining session and the expire date
  /// example:  3 of 6 sessions remaining, valid until March 4th, 2022
  Widget _getEwpDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 13.0,
              color: ConstColors.text),
          children: [
            TextSpan(
                text: '${ewpViewModel.remainingCap} ',
                style: const TextStyle(fontWeight: FontWeight.w600)),
            TextSpan(text: '${translate(LangKeys.of)} '),
            TextSpan(
                text: '${ewpViewModel.orginalCap} ',
                style: const TextStyle(fontWeight: FontWeight.w600)),
            TextSpan(
                text: '${translate(LangKeys.sessionsRemainingValidUntil)} '),
            TextSpan(
                text: _formatDate(ewpViewModel.validTill!),
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  /// the number of session that user attend over the total sessions
  /// attended sessions / total sessions
  Widget _getProgressBar() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 25, left: 4, right: 4, bottom: 5),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(35)),
        child: LinearProgressIndicator(
          minHeight: 5,
          value: ewpViewModel.remainingCap! / ewpViewModel.orginalCap!,
          valueColor: const AlwaysStoppedAnimation<Color>(ConstColors.app),
          backgroundColor: ConstColors.solid,
        ),
      ),
    );
  }

// get the benefits plan for the user
// TODO :: Note that this changeable depending on the backend
  Widget _getBenefitsPlanWidget() {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translate(LangKeys.planBenefits),
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: ConstColors.app,
              fontSize: 16,
            ),
          ),
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: ConstColors.text,
                fontSize: 14,
              ),
              children: [
                const TextSpan(text: '\u2022 '),
                TextSpan(text: '${translate(LangKeys.youHave)} '),
                TextSpan(text: '${ewpViewModel.orginalCap} '),
                TextSpan(text: '${translate(LangKeys.sessionsFullyCovered)} '),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///////////////////////////
  ///// helper methods //////
  ///////////////////////////
  _formatDate(DateTime date) {
    var suffix = "th";
    var digit = date.day % 10;
    if ((digit > 0 && digit < 4) && (date.day < 11 || date.day > 13)) {
      suffix = ["st", "nd", "rd"][digit - 1];
    }
    return DateFormat("MMMM d").format(date) +
        suffix +
        DateFormat(", y").format(date);
  }
}
