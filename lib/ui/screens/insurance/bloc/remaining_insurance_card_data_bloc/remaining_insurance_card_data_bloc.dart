import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/insurance_api_manager.dart';
import 'package:o7therapy/api/models/insurance/get_insurance_card/get_insurance_card.dart';
import 'package:o7therapy/api/models/insurance/remaining_cap_no/remaining_cap_no_model.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/ui/screens/insurance/models/verified_insurance_view_data_model.dart';

part 'remaining_insurance_card_data_event.dart';

part 'remaining_insurance_card_data_state.dart';

class RemainingInsuranceCardDataBloc extends Bloc<
    GetRemainingInsuranceCardDataEvent, RemainingInsuranceCardDataState> {
  RemainingInsuranceCardDataBloc()
      : super(const RemainingInsuranceCardDataInitial()) {
    on<GetRemainingInsuranceCardDataEvent>(
        _onGetRemainingInsuranceCardDataBloc);
  }

  static RemainingInsuranceCardDataBloc bloc(BuildContext context) =>
      context.read<RemainingInsuranceCardDataBloc>();

  _onGetRemainingInsuranceCardDataBloc(
    GetRemainingInsuranceCardDataEvent event,
    emit,
  ) async {
    emit(const LoadingRemainingInsuranceCardData());
    RemainingInsuranceCardDataState? state;
    late final String providerName;
    late final int cardId;
    try {
      /// get insurance card just used to get the provider name
      await InsuranceApiManager.getInsuranceCard(
        success: (GetInsuranceCardWrapper wrapper) async {
          if (wrapper.data[0].cardVerified) {
            providerName = wrapper.data[0].insuranceProvider;
            cardId = wrapper.data[0].cardId;
          } else {
            state = const ExceptionRemainingInsuranceCardData(
                failureMsg: "Unknown error");
          }
        },
        fail: (NetworkExceptions details) async {
          state = const ExceptionRemainingInsuranceCardData(
              failureMsg: "Unknown error");
        },
      );
      await PrefManager.setInsuranceCardId(cardId);
      await InsuranceApiManager.getRemainingInsuranceCard(
        success: (RemainingCapNoModel wrapper) async {
          state = LoadedRemainingInsuranceCardData(
            verifiedInsuranceData:
                VerifiedInsuranceViewDataModel.fromRemainingCapNoModel(wrapper)
                    .copyWith(
              providerName: providerName,
              cardId: cardId,
            ),
          );
        },
        fail: (NetworkExceptions details) async {
          state = ExceptionRemainingInsuranceCardData(
              failureMsg: details.errorMsg ?? "");
        },
      );
    } catch (error) {
      state = const ExceptionRemainingInsuranceCardData(
          failureMsg: "Unknown error");
    }
    emit(state!);
  }
}
