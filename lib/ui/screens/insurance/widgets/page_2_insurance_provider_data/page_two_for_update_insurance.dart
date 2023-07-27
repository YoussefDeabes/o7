import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';

import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/insurance/bloc/insurance_status_bloc/insurance_status_bloc.dart';
import 'package:o7therapy/ui/screens/insurance/mixins/update_insurance_bottom_model_sheet.dart';
import 'package:o7therapy/ui/screens/insurance/models/page_two_insurance_data_model.dart';
import 'package:o7therapy/ui/screens/insurance/models/update_insurance_card_params.dart';
import 'package:o7therapy/ui/screens/insurance/widgets/page_2_insurance_provider_data/insurance_provider_text_field.dart';
import 'package:o7therapy/ui/screens/insurance/widgets/page_2_insurance_provider_data/verify_membership_bottom_sheet.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/ui/screens/insurance/widgets/shared_widgets/shared_widgets.dart';

class PageTwoForUpdateInsurance extends BaseStatefulWidget {
  const PageTwoForUpdateInsurance({
    super.key,
    required this.insuranceData,
    super.backGroundColor = Colors.transparent,
  });
  final PageTwoInsuranceDataModel insuranceData;

  @override
  BaseState<BaseStatefulWidget> baseCreateState() {
    return _PageTwoForUpdateInsurance();
  }
}

class _PageTwoForUpdateInsurance extends BaseState<PageTwoForUpdateInsurance>
    with UpdateInsuranceBottomModelSheet {
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
      child: Container(
        padding:
            const EdgeInsetsDirectional.only(start: 24, end: 24, bottom: 24),
        constraints: BoxConstraints(maxHeight: height * 0.85),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 28),
              child: ChangeInsuranceTextWidget(),
            ),
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
                  // const SizedBox(height: 15),
                ],
              ),
            ),
            const Spacer(),
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
  /// then if cubit returned true >> that it was send successfully
  /// and show to bottom sheet
  Widget _getValidateButton() {
    return BlocListener<InsuranceStatusBloc, InsuranceStatusState>(
      listener: (context, state) {
        if (state is LoadingInsuranceStatus) {
          showLoading();
        } else {
          hideLoading();
        }
        if (state is UnVerifiedInsuranceStatus) {
          /// it will pop the previous 2 bottom sheets of the update
          /// 1- bottom model sheets of choose the provider
          /// 2- bottom model sheets of enter the card number while updating
          Navigator.pop(context);
          Navigator.pop(context);
          showUpdateInsuranceBottomSheet(
            context: context,
            child: VerifyMembershipBottomSheet(
              membershipNumber:
                  int.tryParse(membershipNumberController.text) ?? 0,
              providerName:
                  widget.insuranceData.providerData?.providerName ?? "",
            ),
          );
        }
      },
      child: InsurancePageButton(
        width: width * 0.3,
        onPressed: () async {
          log("validate Pressed to go to Validate page >> insurance screen");
          InsuranceStatusBloc insuranceStatusBloc =
              InsuranceStatusBloc.bloc(context);
          int? oldInsuranceCardId = await PrefManager.getInsuranceCardId();
          insuranceStatusBloc.add(
            UpdateInsuranceCardEvent(
              params: UpdateInsuranceCardParams(
                medicalCardNumber: membershipNumberController.text,
                insuranceCompanyId:
                    widget.insuranceData.providerData?.providerId ?? -1,
                oldUserCardId: oldInsuranceCardId ?? -1,
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
