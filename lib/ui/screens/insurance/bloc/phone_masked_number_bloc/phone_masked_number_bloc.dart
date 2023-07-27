import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/api/insurance_api_manager.dart';
import 'package:o7therapy/api/models/insurance/model/phone_masked_number_model.dart';

part 'phone_masked_number_event.dart';
part 'phone_masked_number_state.dart';

class PhoneMaskedNumberBloc
    extends Bloc<GetPhoneMaskedNumberEvent, PhoneMaskedNumberState> {
  PhoneMaskedNumberBloc() : super(const PhoneMaskedNumberState("")) {
    on<GetPhoneMaskedNumberEvent>(_onGetPhoneMaskedNumberEvent);
  }

  static PhoneMaskedNumberBloc bloc(BuildContext context) =>
      context.read<PhoneMaskedNumberBloc>();

  _onGetPhoneMaskedNumberEvent(GetPhoneMaskedNumberEvent event, emit) async {
    PhoneMaskedNumberState? state;
    await InsuranceApiManager.getPhoneMaskedNumberApi(
      cardNumber: event.cardNumber,
      success: (PhoneMaskedNumberModel model) {
        state = PhoneMaskedNumberState(model.data);
      },
      fail: (model) {
        state = const PhoneMaskedNumberState("");
      },
    );
    emit(state);
  }
}
