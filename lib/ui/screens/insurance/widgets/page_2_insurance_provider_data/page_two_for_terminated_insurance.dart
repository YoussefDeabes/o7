import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/insurance/bloc/insurance_status_bloc/insurance_status_bloc.dart';
import 'package:o7therapy/ui/screens/insurance/mixins/cancel_insurance_bottom_model_sheet/cancel_insurance_bottom_model_sheet.dart';
import 'package:o7therapy/ui/screens/insurance/mixins/update_insurance_bottom_model_sheet.dart';
import 'package:o7therapy/ui/screens/insurance/mixins/validation_bottom_model_sheet.dart';
import 'package:o7therapy/ui/screens/insurance/models/page_two_insurance_data_model.dart';
import 'package:o7therapy/ui/screens/insurance/bloc/send_verification_code_bloc/send_verification_code_bloc.dart';
import 'package:o7therapy/ui/screens/insurance/screen/verified_insurance_screen.dart';
import 'package:o7therapy/ui/screens/insurance/widgets/page_1_search_insurance_provider/page_1_search_insurance_provider_for_update.dart';
import 'package:o7therapy/ui/screens/insurance/widgets/page_2_insurance_provider_data/date_time_text_field.dart';
import 'package:o7therapy/ui/screens/insurance/widgets/page_2_insurance_provider_data/insurance_provider_text_field.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/ui/screens/insurance/widgets/shared_widgets/shared_widgets.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';

class PageTwoForTerminatedInsurance extends BaseStatefulWidget {
  const PageTwoForTerminatedInsurance({
    super.key,
    required this.cardId,
    required this.insuranceData,
  });
  final PageTwoInsuranceDataModel insuranceData;
  final int cardId;

  @override
  BaseState<BaseStatefulWidget> baseCreateState() {
    return _PageTwoForTerminatedInsurance();
  }
}

class _PageTwoForTerminatedInsurance
    extends BaseState<PageTwoForTerminatedInsurance>
    with
        validationBottomModelSheet,
        CancelInsuranceBottomModelSheet,
        UpdateInsuranceBottomModelSheet {
  TextEditingController membershipNumberController = TextEditingController();

  TextEditingController dateTimeController = TextEditingController();
  @override
  void initState() {
    if (widget.insuranceData.membershipNo != null) {
      membershipNumberController.text =
          widget.insuranceData.membershipNo.toString();
    }
    if (widget.insuranceData.expirationDate != null) {
      dateTimeController.text = DateFormat('dd/MMM/yyyy')
          .format(widget.insuranceData.expirationDate!);
    }

    super.initState();
  }

  @override
  Widget baseBuild(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: height * 0.85),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            InsurancePageRoundedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translate(LangKeys.insuranceProvider),
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: ConstColors.text,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _getInsuranceProviderName(),
                  const SizedBox(height: 20),
                  _getMembershipNumberTextField(),
                  const SizedBox(height: 15),
                  // DateTimeTextField(dateTimeController: dateTimeController),
                  const SizedBox(height: 15),
                ],
              ),
            ),
            _getUnVerifiedErrorText(),
            Container(
                alignment: AlignmentDirectional.centerEnd,
                margin: EdgeInsets.symmetric(vertical: height * 0.035),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _getCancelButton(),
                    SizedBox(width: width * 0.03),
                    _getValidateButton(),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  /// cooperate User Choose before
  Text _getInsuranceProviderName() {
    return Text(
      widget.insuranceData.providerData!.providerName,
      textAlign: TextAlign.start,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: ConstColors.app,
      ),
    );
  }

  Widget _getUnVerifiedErrorText() {
    return const Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          "You are no longer covered under this Insurance Provider. Would you like to change your insurance status?",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: ConstColors.error,
          ),
        ),
      ),
    );
  }

  /// Get Validate button to navigate to Check the insurance
  /// send that user need to validate the insurance first
  /// then if cubit returned true >> that it was send successfully
  /// and show to bottom sheet
  Widget _getValidateButton() {
    return MultiBlocListener(
      listeners: [
        BlocListener<SendVerificationCodeBloc, SendVerificationCodeState>(
          listener: (context, state) {
            if (state is SentCodeVerification) {
              int? membershipNumber =
                  int.tryParse(membershipNumberController.text);
              String? providerName =
                  widget.insuranceData.providerData?.providerName;
              if (membershipNumber != null && providerName != null) {
                showValidationBottomSheet(
                  context: context,
                  membershipNumber: membershipNumber,
                  providerName: providerName,
                );
              } else {
                showToast("Not valid number");
              }
            } else if (state is ExceptionSendCodeVerification) {
              if (state.msg == "Session expired") {
                clearData();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    LoginScreen.routeName, (Route<dynamic> route) => false);
              }
              showToast(state.msg);
            } else if (state is NotSentCodeVerification) {
              showToast(translate(LangKeys.tryAgainLater));
            }
          },
        ),
        BlocListener<InsuranceStatusBloc, InsuranceStatusState>(
          listener: (context, state) {
            if (state is LoadingInsuranceStatus) {
              showLoading();
            } else {
              hideLoading();
            }
            if (state is ExceptionInsuranceStatus) {
              if (state.failureMsg == "Session expired") {
                clearData();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    LoginScreen.routeName, (Route<dynamic> route) => false);
              }
              showToast(state.failureMsg);
            }
            // if (state is SuccessVerifiedInsuranceStatus) {
            //   Navigator.of(context).pushNamedAndRemoveUntil(
            //     VerifiedInsuranceScreen.routeName,
            //     (route) =>
            //         route.settings.name == HomeMainLoggedInScreen.routeName,
            //   );
            // }
          },
        )
      ],
      child: InsurancePageButton(
        width: width * 0.3,
        onPressed: () {
          showUpdateInsuranceBottomSheet(
            context: context,
            child: const PageOneSearchInsuranceProviderForUpdate(),
          );
        },
        buttonLabel: translate(LangKeys.change),
      ),
    );
  }

  /// Get cancel button to cancel and back to first page
  Widget _getCancelButton() {
    return InsurancePageButton(
      buttonColor: ConstColors.appWhite,
      fontColor: ConstColors.app,
      width: width * 0.3,
      onPressed: () {
        showCancelInsuranceBottomSheet(
          context: context,
          cardId: widget.cardId,
        );
      },
      buttonLabel: translate(LangKeys.cancel),
    );
  }

  Widget _getMembershipNumberTextField() {
    return InsuranceProviderTextField(
      labelText: translate(LangKeys.membershipNo),
      hintText: translate(LangKeys.no),
      keyboardType: TextInputType.number,
      controller: membershipNumberController,
    );
  }

  @override
  void dispose() {
    // Clean up.
    dateTimeController.dispose();
    membershipNumberController.dispose();

    super.dispose();
  }
}
