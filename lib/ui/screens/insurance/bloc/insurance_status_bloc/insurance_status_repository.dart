import 'package:o7therapy/api/api_manager.dart';
import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/insurance_api_manager.dart';

import 'dart:developer';
import 'package:o7therapy/api/models/insurance/added_insurance_card/added_insurance_card_model.dart';
import 'package:o7therapy/api/models/insurance/deleted_insurance_card/deleted_insurance_card_model.dart';

import 'package:o7therapy/api/models/insurance/get_insurance_card/get_insurance_card.dart';
import 'package:o7therapy/api/models/insurance/update_insurance_card/update_insurance_card_model.dart';
import 'package:o7therapy/api/models/insurance/validate_otp_insurance_card/validate_otp_insurance_card_wrapper.dart';
import 'package:o7therapy/api/models/insurance_deal/InsuranceDeal.dart';
import 'package:o7therapy/ui/screens/insurance/bloc/insurance_status_bloc/insurance_status_bloc.dart';
import 'package:o7therapy/ui/screens/insurance/models/membership_data.dart';
import 'package:o7therapy/ui/screens/insurance/models/page_two_insurance_data_model.dart';
import 'package:o7therapy/ui/screens/insurance/models/update_insurance_card_params.dart';

/// States <<5>> :: ExceptionInsuranceStatus NoInsuranceStatus VerifiedInsuranceStatus UnVerifiedInsuranceStatus
abstract class BaseInsuranceStatusRepository {
  const BaseInsuranceStatusRepository();

  Future<InsuranceStatusState> getInsuranceStatus();

  Future<InsuranceStatusState> validateOtpInsuranceCard({
    required String otp,
    required String cardNumber,
  });

  Future<InsuranceStatusState> addNewInsurance({
    required PageTwoInsuranceDataModel newInsuranceData,
  });

  Future<InsuranceStatusState> deleteInsurance({required int cardId});

  Future<InsuranceStatusState> updateInsuranceCard({
    required UpdateInsuranceCardParams params,
  });

  Future<InsuranceStatusState> getInsuranceDeal(String slotId, String slotDate);
}

class InsuranceStatusRepository extends BaseInsuranceStatusRepository {
  const InsuranceStatusRepository();

  @override
  Future<InsuranceStatusState> getInsuranceStatus() async {
    InsuranceStatusState? state;
    try {
      await InsuranceApiManager.getInsuranceCard(
        success: (GetInsuranceCardWrapper wrapper) async {
          // the coming line state is the initial one and then will be overwritten
          state = const NoInsuranceStatus();
          log("getInsuranceCard in repo :: ${wrapper.data}");
          if (wrapper.data.isEmpty) {
            state = const NoInsuranceStatus();
          } else if (wrapper.data[0].cardVerified) {
            state = const VerifiedInsuranceStatus();
            MembershipData().setData(wrapper.data[0].medicalCardNumber);
          } else {
            state = UnVerifiedInsuranceStatus(insuranceCard: wrapper.data[0]);
            MembershipData().setData(wrapper.data[0].medicalCardNumber);
          }
        },
        fail: (NetworkExceptions details) {
          state = ExceptionInsuranceStatus(
            failureMsg: details.errorMsg ?? "Oops.. SomeThing Went Wrong!",
          );
        },
      );
    } catch (error) {
      state = const ExceptionInsuranceStatus(
          failureMsg: "Oops.. SomeThing Went Wrong!");
    }
    return state!;
  }

  @override
  Future<InsuranceStatusState> validateOtpInsuranceCard({
    required String otp,
    required String cardNumber,
  }) async {
    InsuranceStatusState? state;
    try {
      await InsuranceApiManager.validateOtpInsuranceCard(
        otp: otp,
        cardNumber: cardNumber,
        success: (ValidateOtpInsuranceWrapper wrapper) async {
          if (wrapper.data == null || wrapper.data == false) {
            state = const ExceptionInsuranceStatus(
                failureMsg: "Oops.. SomeThing Went Wrong!");
          } else {
            /// here the wrapper.data == true
            /// the insurance card now is verified and need to navigate to verified screen
            /// then get the remaining data to open page 3 verified insurance
            state = const SuccessVerifiedInsuranceStatus();
          }
        },
        fail: (NetworkExceptions details) {
          state = ExceptionInsuranceStatus(
              failureMsg: details.errorMsg ?? "Oops.. SomeThing Went Wrong!");
        },
      );
    } catch (error) {
      state = const ExceptionInsuranceStatus(
          failureMsg: "Oops.. SomeThing Went Wrong!");
    }
    return state!;
  }

  @override
  Future<InsuranceStatusState> addNewInsurance({
    required PageTwoInsuranceDataModel newInsuranceData,
  }) async {
    InsuranceStatusState? state;
    try {
      await InsuranceApiManager.addInsuranceCard(
        membershipNumber: newInsuranceData.membershipNo.toString(),
        providerId: newInsuranceData.providerData!.providerId,
        success: (AddedInsuranceCardWrapper wrapper) async {
          if (wrapper.data != null && wrapper.data == true) {
            state = const SuccessAddedInsuranceCardStatus();
          } else {
            state = const ExceptionInsuranceStatus(
                failureMsg: "Oops.. SomeThing Went Wrong!");
          }
        },
        fail: (NetworkExceptions details) {
          state = ExceptionInsuranceStatus(
              failureMsg: details.errorMsg ?? "Oops.. SomeThing Went Wrong!");
        },
      );
    } catch (error) {
      state = const ExceptionInsuranceStatus(
          failureMsg: "Oops.. SomeThing Went Wrong!");
    }
    return state!;
  }

  @override
  Future<InsuranceStatusState> deleteInsurance({required int cardId}) async {
    InsuranceStatusState? state;
    try {
      await InsuranceApiManager.deleteInsuranceCard(
        cardId: cardId,
        success: (DeletedInsuranceCardWrapper wrapper) {
          if (wrapper.data == true) {
            state = const NoInsuranceStatus();
          } else {
            state = const ExceptionInsuranceStatus(
                failureMsg: "Oops.. SomeThing Went Wrong!");
          }
        },
        fail: (NetworkExceptions details) {
          state = ExceptionInsuranceStatus(
              failureMsg: details.errorMsg ?? "Oops.. SomeThing Went Wrong!");
        },
      );
    } catch (error) {
      state = const ExceptionInsuranceStatus(
          failureMsg: "Oops.. SomeThing Went Wrong!");
    }
    return state!;
  }

  @override
  Future<InsuranceStatusState> updateInsuranceCard({
    required UpdateInsuranceCardParams params,
  }) async {
    InsuranceStatusState? state;
    try {
      await InsuranceApiManager.updateInsuranceCard(
        params: params,
        success: (UpdateInsuranceCardWrapper wrapper) {
          if (wrapper.data != null && wrapper.data!) {
            state = const SuccessUpdatedInsuranceCard();
          } else {
            state = const ExceptionInsuranceStatus(
                failureMsg: "Oops.. The insurance card not updated!");
          }
        },
        fail: (NetworkExceptions details) {
          state = ExceptionInsuranceStatus(
              failureMsg: details.errorMsg ?? "Oops.. SomeThing Went Wrong!");
        },
      );
    } catch (error) {
      state = const ExceptionInsuranceStatus(
          failureMsg: "Oops.. SomeThing Went Wrong!");
    }
    return state!;
  }

  @override
  Future<InsuranceStatusState> getInsuranceDeal(
      String slotId, String slotDate) async {
    InsuranceStatusState? insuranceStatusState;

    try {
      await ApiManager.verifyInsuranceDeal(slotId,
          (InsuranceDeal insuranceDeal) {
        insuranceStatusState =
            InsuranceDealState(insuranceDeal, slotId, slotDate);
      }, (NetworkExceptions details) {
        insuranceStatusState = ExceptionInsuranceStatus(
            failureMsg: details.errorMsg ?? "Oops.. SomeThing Went Wrong!");
      });
    } catch (error) {
      insuranceStatusState = const ExceptionInsuranceStatus(
          failureMsg: "Oops.. SomeThing Went Wrong!");
    }
    return insuranceStatusState!;
  }
}
