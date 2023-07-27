part of 'rassel_bloc.dart';

@immutable
abstract class RasselEvent {}

class RasselInitialEvt extends RasselEvent {}

class RasselIsSubscribedEvt extends RasselEvent {
  String subscriptionId;
  num amount;
  num currency;

  RasselIsSubscribedEvt(
      {required this.subscriptionId,
      required this.amount,
      required this.currency});
}

class RasselClientSubscriptionsEvt extends RasselEvent {}

class RasselCalculateSubscriptionFeesEvt extends RasselEvent {
  CalculateSubscriptionSendModel subscribeSendModel;

  RasselCalculateSubscriptionFeesEvt({required this.subscribeSendModel});
}

class RasselCancelSubscriptionEvt extends RasselEvent {
  String clientSubscriptionId;

  RasselCancelSubscriptionEvt({required this.clientSubscriptionId});
}

class RasselSubscribeEvt extends RasselEvent {
  SubscribeSendModel subscribeSendModel;

  RasselSubscribeEvt({required this.subscribeSendModel});
}

class RasselMonthFreeTrialEvt extends RasselEvent {}

class RasselMissedMessagesEvt extends RasselEvent {}
