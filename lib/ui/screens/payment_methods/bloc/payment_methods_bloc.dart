import 'package:bloc/bloc.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:o7therapy/api/models/credit_card/CreditCard.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/ui/screens/payment_methods/bloc/payment_methods_repo.dart';

part 'payment_methods_event.dart';

part 'payment_methods_state.dart';

class PaymentMethodsBloc
    extends Bloc<PaymentMethodsEvent, PaymentMethodsState> {
  final BasePaymentMethodsRepo _baseRepo;

  PaymentMethodsBloc(this._baseRepo) : super(PaymentMethodsInitial()) {
    on<PaymentMethodsSuccessEvent>(_onCreditCardsLoading);
    on<SetAsPreferredEvt>(_onSetAsPreferred);
    on<DeleteCardEvt>(_onDeleteCard);
    on<AddCardEvt>(_onAddCard);
  }

  _onCreditCardsLoading(PaymentMethodsSuccessEvent event, emit) async {
    emit(PaymentMethodsLoadingState());
    emit(await _baseRepo.savedCards());
  }

  _onDeleteCard(DeleteCardEvt event, emit) async {
    emit(PaymentMethodsLoadingState());
    emit(await _baseRepo.deleteCard(event.code));
  }

  _onSetAsPreferred(SetAsPreferredEvt event, emit) async {
    emit(PaymentMethodsLoadingState());
    emit(await _baseRepo.setAsPreferred(event.code));
  }

  _onAddCard(AddCardEvt event, emit) async {
    emit(PaymentMethodsLoadingState());
    String userIp = await Ipify.ipv4();
    String? token = await PrefManager.getToken();
    String? id = await PrefManager.getId();
    String? countryCode = await PrefManager.getCountryCode();
    emit(AddCardState(userIp: userIp, userId: id!, userToken: token!,countryCode: countryCode!));
  }
}
