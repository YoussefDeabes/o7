import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:o7therapy/api/models/calculate_subscription_fees/CalculateSubscriptionFees.dart';
import 'package:o7therapy/api/models/calculate_subscription_send_model/calculate_subscription_send_model.dart';
import 'package:o7therapy/api/models/rassel_subscription/RasselSubscription.dart';
import 'package:o7therapy/api/models/subscribe/Subscribe.dart';
import 'package:o7therapy/api/models/subscription_send_model/subscribe_send_model.dart';
import 'package:o7therapy/ui/screens/rassel/bloc/checkout_bloc/rassel_checkout_repo.dart';

part 'rassel_checkout_event.dart';
part 'rassel_checkout_state.dart';

class RasselCheckoutBloc extends Bloc<RasselCheckoutEvent, RasselCheckoutState> {
  final BaseRasselCheckoutRepo _baseRepo;

  RasselCheckoutBloc(this._baseRepo) : super(RasselLoadingState()) {
    on<RasselCheckoutInitEvt>(_onRasselCheckoutEvt);
    on<RasselCalculateSubscriptionFeesEvt>(_onRasselCalculateSubscriptionFeesEvt);
    on<PayNowRasselSubscribeEvent>(_onPayNowRasselSubscribePressed);
  }

  _onRasselCheckoutEvt(RasselCheckoutInitEvt event, emit) async {
    emit(RasselLoadingState());
    emit(await _baseRepo.getRasselCheckout());
  }

  _onRasselCalculateSubscriptionFeesEvt(
      RasselCalculateSubscriptionFeesEvt event, emit) async {
    emit(RasselLoadingState());
    emit(await _baseRepo.calculateSubscriptionFees(
      subscriptionId: event.subscriptionId,
        subscribeModel: event.subscribeSendModel));
  }
  _onPayNowRasselSubscribePressed(
      PayNowRasselSubscribeEvent event, emit) async {
    SubscribeSendModel model = SubscribeSendModel(
        clientType: event.clientType,
        currency: event.currency,
        subscriptionId: event.clientSubscriptionId);
    emit(RasselLoadingState());
    emit(await _baseRepo.subscribeRassel(model));
  }
}
