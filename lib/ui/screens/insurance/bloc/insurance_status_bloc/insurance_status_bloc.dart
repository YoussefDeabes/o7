import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/api/models/insurance/get_insurance_card/get_insurance_card.dart';
import 'package:o7therapy/api/models/insurance_deal/InsuranceDeal.dart';
import 'package:o7therapy/ui/screens/insurance/bloc/insurance_list_bloc/insurance_list_bloc.dart';
import 'package:o7therapy/ui/screens/insurance/bloc/insurance_status_bloc/insurance_status_repository.dart';
import 'package:o7therapy/ui/screens/insurance/bloc/send_verification_code_bloc/send_verification_code_bloc.dart';
import 'package:o7therapy/ui/screens/insurance/models/page_two_insurance_data_model.dart';
import 'package:o7therapy/ui/screens/insurance/models/update_insurance_card_params.dart';

part 'insurance_status_event.dart';
part 'insurance_status_state.dart';

class InsuranceStatusBloc
    extends Bloc<InsuranceStatusEvent, InsuranceStatusState> {
  final BaseInsuranceStatusRepository _statusRepository;

  InsuranceStatusBloc({
    required BaseInsuranceStatusRepository statusRepository,
  })  : _statusRepository = statusRepository,
        super(const InitInsuranceStatusState()) {
    on<GetInsuranceStatusEvent>(_onGetInsuranceStatusEvent);
    on<ValidateOtpInsuranceStatusEvent>(_onValidateOtpInsuranceStatusEvent);
    on<AddNewInsuranceEvent>(_onAddNewInsuranceEvent);
    on<DeleteInsuranceEvent>(_onDeleteInsuranceEvent);
    on<UpdateInsuranceCardEvent>(_onUpdateInsuranceCardEvent);
    on<GetInsuranceDealEvent>(_onGetInsuranceDealEvent);
  }

  static InsuranceStatusBloc bloc(BuildContext context) =>
      context.read<InsuranceStatusBloc>();

  /// this event will trigger when the user clicks on insurance at more screen
  /// and depend on status the user will navigate to
  /// 1. LoadingInsuranceStatus >> wait
  /// 2. NoInsuranceStatus >> SearchProvidersInsuranceScreen
  /// 3. VerifiedInsuranceStatus >> VerifiedInsuranceScreen
  /// 4. UnVerifiedInsuranceStatus >> EditInsuranceDataScreenState with hint error
  _onGetInsuranceStatusEvent(GetInsuranceStatusEvent event, emit) async {
    emit(const LoadingInsuranceStatus());
    emit(await _statusRepository.getInsuranceStatus());
  }

  _onValidateOtpInsuranceStatusEvent(
      ValidateOtpInsuranceStatusEvent event, emit) async {
    emit(const LoadingInsuranceStatus());
    emit(await _statusRepository.validateOtpInsuranceCard(
      cardNumber: event.cardNumber,
      otp: event.otp,
    ));
  }

  _onAddNewInsuranceEvent(AddNewInsuranceEvent event, emit) async {
    emit(const LoadingInsuranceStatus());
    InsuranceStatusState state = await _statusRepository.addNewInsurance(
      newInsuranceData: event.addNewInsuranceDataModel,
    );

    /// if the card added successfully
    /// then get the current insurance state
    /// we must get the data
    /// the status will be UnVerifiedInsuranceStatus
    /// because he add and get then the user must verify
    if (state is SuccessAddedInsuranceCardStatus) {
      state = await _statusRepository.getInsuranceStatus();
    }

    emit(state);
  }

  /// when user press cancel at page two if not verified yet
  /// or if the uer verified and need to delete cancel
  _onDeleteInsuranceEvent(DeleteInsuranceEvent event, emit) async {
    emit(const LoadingInsuranceStatus());
    emit(await _statusRepository.deleteInsurance(cardId: event.cardId));
  }

  _onUpdateInsuranceCardEvent(UpdateInsuranceCardEvent event, emit) async {
    emit(const LoadingInsuranceStatus());

    InsuranceStatusState state =
        await _statusRepository.updateInsuranceCard(params: event.params);

    /// if the card updated successfully
    /// then get the current insurance state
    /// the status will be UnVerifiedInsuranceStatus
    /// because he add and get then the user must verify
    if (state is SuccessUpdatedInsuranceCard) {
      state = await _statusRepository.getInsuranceStatus();
    }
    emit(state);
  }

  _onGetInsuranceDealEvent(GetInsuranceDealEvent event, emit) async {
    emit(const LoadingInsuranceStatus());
    emit(await _statusRepository.getInsuranceDeal(
        event.availableSlotId, event.slotDate));
  }
}
