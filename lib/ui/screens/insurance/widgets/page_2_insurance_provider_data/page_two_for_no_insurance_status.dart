import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';

import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/insurance/bloc/insurance_status_bloc/insurance_status_bloc.dart';
import 'package:o7therapy/ui/screens/insurance/mixins/validation_bottom_model_sheet.dart';
import 'package:o7therapy/ui/screens/insurance/models/page_two_insurance_data_model.dart';
import 'package:o7therapy/ui/screens/insurance/bloc/send_verification_code_bloc/send_verification_code_bloc.dart';
import 'package:o7therapy/ui/screens/insurance/widgets/page_2_insurance_provider_data/date_time_text_field.dart';
import 'package:o7therapy/ui/screens/insurance/widgets/page_2_insurance_provider_data/insurance_provider_text_field.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/ui/screens/insurance/widgets/shared_widgets/shared_widgets.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';

class PageTwoForNoInsuranceStatus extends BaseStatefulWidget {
  const PageTwoForNoInsuranceStatus({super.key, required this.insuranceData});
  final PageTwoInsuranceDataModel insuranceData;

  @override
  BaseState<BaseStatefulWidget> baseCreateState() {
    return _PageTwoForNoInsuranceStatus();
  }
}

class _PageTwoForNoInsuranceStatus
    extends BaseState<PageTwoForNoInsuranceStatus>
    with validationBottomModelSheet {
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
            Container(
                alignment: AlignmentDirectional.centerEnd,
                margin: EdgeInsets.symmetric(vertical: height * 0.035),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BackButtonForInsuranceScreen(),
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

  /// Get Validate button to navigate to Check the insurance
  /// send that user need to validate the insurance first
  /// and show to bottom sheet
  Widget _getValidateButton() {
    return BlocListener<InsuranceStatusBloc, InsuranceStatusState>(
      listener: (context, state) {
        if (state is ExceptionInsuranceStatus) {
          if (state.failureMsg == "Session expired") {
            clearData();
            Navigator.of(context).pushNamedAndRemoveUntil(
                LoginScreen.routeName, (Route<dynamic> route) => false);
          }
          showToast(state.failureMsg);
        }

        if (state is UnVerifiedInsuranceStatus) {
          // pop current screen >> page two when added new insurance
          // and then back to the insurance screen
          // insurance screen >> its body will replaced with unverified screen instead of choose provider
          Navigator.pop(context);
          int? membershipNumber = int.tryParse(membershipNumberController.text);
          showValidationBottomSheet(
            context: context,
            membershipNumber: membershipNumber!,
            providerName: widget.insuranceData.providerData!.providerName,
          );
          showToast("Card Added Successfully");
        }
      },
      child: InsurancePageButton(
        width: width * 0.3,
        onPressed: () {
          log("validate Pressed to go to Validate page >> insurance screen");
          InsuranceStatusBloc insuranceStatusBloc =
              InsuranceStatusBloc.bloc(context);
          int? membershipNumber = int.tryParse(membershipNumberController.text);

          // the status no insurance yet
          // then add the insurance first then Send the Send Verification code
          insuranceStatusBloc.add(
            AddNewInsuranceEvent(
              addNewInsuranceDataModel: PageTwoInsuranceDataModel(
                membershipNo: membershipNumber,
                providerData: widget.insuranceData.providerData,
              ),
            ),
          );
        },
        buttonLabel: translate(LangKeys.validate),
      ),
    );
  }

  Widget _getMembershipNumberTextField() {
    return InsuranceProviderTextField(
      labelText: translate(LangKeys.membershipNo),
      hintText: translate(LangKeys.no),
      keyboardType: TextInputType.number,
      controller: membershipNumberController,
      autoFocus: true,
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
