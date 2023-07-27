part of 'rassel_checkout_bloc.dart';

@immutable
abstract class RasselCheckoutEvent {}

class RasselCheckoutInitEvt extends RasselCheckoutEvent {

  RasselCheckoutInitEvt();
}

class RasselCalculateSubscriptionFeesEvt extends RasselCheckoutEvent {
  CalculateSubscriptionSendModel subscribeSendModel;
  num? subscriptionId;

  RasselCalculateSubscriptionFeesEvt({required this.subscribeSendModel,required this.subscriptionId});
}

class PayNowRasselSubscribeEvent extends RasselCheckoutEvent {
  final int clientSubscriptionId;
  final int currency;
  final int clientType;

  PayNowRasselSubscribeEvent({required this.clientSubscriptionId,required this.currency,required this.clientType});
}

class RasselCheckoutEvt extends RasselCheckoutEvent{}
