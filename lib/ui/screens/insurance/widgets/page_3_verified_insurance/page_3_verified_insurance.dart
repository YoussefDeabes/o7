import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/ui/screens/insurance/bloc/insurance_status_bloc/insurance_status_bloc.dart';
import 'package:o7therapy/ui/screens/insurance/mixins/cancel_insurance_bottom_model_sheet/cancel_insurance_bottom_model_sheet.dart';
import 'package:o7therapy/ui/screens/insurance/mixins/update_insurance_bottom_model_sheet.dart';
import 'package:o7therapy/ui/screens/insurance/models/membership_data.dart';
import 'package:o7therapy/ui/screens/insurance/models/verified_insurance_view_data_model.dart';
import 'package:o7therapy/ui/screens/insurance/widgets/page_1_search_insurance_provider/page_1_search_insurance_provider_for_update.dart';
import 'package:o7therapy/ui/screens/insurance/widgets/shared_widgets/shared_widgets.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class PageThreeVerifiedInsurance extends BaseStatefulWidget {
  final VerifiedInsuranceViewDataModel verifiedInsuranceData;
  const PageThreeVerifiedInsurance(
      {required this.verifiedInsuranceData, super.key});

  @override
  BaseState<BaseStatefulWidget> baseCreateState() {
    return _PageThreeVerifiedInsuranceState();
  }
}

class _PageThreeVerifiedInsuranceState
    extends BaseState<PageThreeVerifiedInsurance>
    with UpdateInsuranceBottomModelSheet, CancelInsuranceBottomModelSheet {
  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            _getInsuranceProviderName(),
            const SizedBox(height: 6),
            _getMembershipNoText(),
            _getClientMembershipNumber(),

            // container contain the details of the Insurance
            InsurancePageRoundedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _getRemainingSessions(
                      widget.verifiedInsuranceData.remainingCap),
                  _getExpirationDetails(),
                  _getProgressBar(),
                  _getTotalSessionsNumber(),
                ],
              ),
            ),

            const SizedBox(height: 20),
            _getBenefitsPlanWidget(),
            SizedBox(height: 0.07 * height),
          ],
        ),
        Container(
          alignment: AlignmentDirectional.centerEnd,
          margin: EdgeInsets.symmetric(vertical: height * 0.035),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _getCancelInsuranceButton(),
              SizedBox(width: width * 0.03),
              _getChangeButton(context),
            ],
          ),
        )
      ],
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

  /// get name of the Insurance company
  Widget _getInsuranceProviderName() {
    return Text(
      "${widget.verifiedInsuranceData.providerName} ${translate(LangKeys.insurancePlan)}",
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: ConstColors.text,
      ),
    );
  }

// get MembershipNo Fixed Text only
  Widget _getMembershipNoText() {
    return Text(
      translate(LangKeys.membershipNo),
      style: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: ConstColors.textSecondary,
      ),
    );
  }

  // get MembershipNo
  Widget _getClientMembershipNumber() {
    return Text(
      MembershipData().membershipNumber,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: ConstColors.textSecondary,
      ),
    );
  }

  /// get Remaining Number Of Sessions
  Widget _getRemainingSessions(int numberOfRemainingSessions) {
    return Text(
      numberOfRemainingSessions.toString(),
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 40,
        color: ConstColors.accentColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _getExpirationDetails() {
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
                  text: '${widget.verifiedInsuranceData.remainingCap} ',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              TextSpan(text: '${translate(LangKeys.of)} '),
              TextSpan(
                  text: '${widget.verifiedInsuranceData.originalCap} ',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              TextSpan(
                  text: '${translate(LangKeys.sessionsRemainingValidUntil)} '),
              TextSpan(
                  text:
                      _formatDate(widget.verifiedInsuranceData.expirationTime),
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ));
  }

  Widget _getTotalSessionsNumber() {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Text(
        "${widget.verifiedInsuranceData.originalCap} ${translate(LangKeys.sessions)}",
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 10,
          color: ConstColors.app,
        ),
      ),
    );
  }

  /// the number of session that user attend over the total sessions
  /// attended sessions / total sessions
  Widget _getProgressBar() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 25, left: 5, right: 5, bottom: 5),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(35)),
        child: LinearProgressIndicator(
          minHeight: 5,
          value: widget.verifiedInsuranceData.remainingCap /
              widget.verifiedInsuranceData.originalCap,
          valueColor: const AlwaysStoppedAnimation<Color>(ConstColors.app),
          backgroundColor: ConstColors.solid,
        ),
      ),
    );
  }

// get the benefits plan for the user
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
                TextSpan(text: '${widget.verifiedInsuranceData.originalCap} '),
                TextSpan(text: '${translate(LangKeys.sessionsFullyCovered)} '),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Get cancel button to cancel
  Widget _getCancelInsuranceButton() {
    return InsurancePageButton(
      buttonColor: ConstColors.appWhite,
      fontColor: ConstColors.app,
      width: width * 0.5,
      onPressed: () {
        // cancel should back to the previous page
        showCancelInsuranceBottomSheet(
            context: context, cardId: widget.verifiedInsuranceData.cardId!);
      },
      buttonLabel: translate(LangKeys.cancelInsurance),
    );
  }

  /// Get Change button to change insurance card
  Widget _getChangeButton(BuildContext context) {
    return InsurancePageButton(
      width: width * 0.3,
      onPressed: () {
        showUpdateInsuranceBottomSheet(
          context: context,
          child: const PageOneSearchInsuranceProviderForUpdate(),
        );
      },
      buttonLabel: translate(LangKeys.change),
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
