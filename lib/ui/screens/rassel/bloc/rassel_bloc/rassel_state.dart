part of 'rassel_bloc.dart';

@immutable
abstract class RasselState {
  const RasselState();
}

class RasselInitial extends RasselState {}

class RasselLoadingState extends RasselState {}

class RasselSubscriptionState extends RasselState {
  RasselSubscription rasselSubscription;

  RasselSubscriptionState({required this.rasselSubscription});
}

class RasselSubscribedState extends RasselState {

  RasselSubscribedState();
}
class RasselNotSubscribedState extends RasselState {
  final num amount;
  final num currency;
  RasselNotSubscribedState({required this.amount,required this.currency});
}

class RasselClientSubscriptionState extends RasselState {
  RasselClientSubscriptionsWithResubscribe? rasselClientSubscriptions;

  RasselClientSubscriptionState(this.rasselClientSubscriptions);
}

class RasselCalculateSubscriptionFeesState extends RasselState {
  CalculateSubscriptionFees calculateSubscriptionFees;

  RasselCalculateSubscriptionFeesState(this.calculateSubscriptionFees);
}

class RasselCancelSubscriptionState extends RasselState {
  const RasselCancelSubscriptionState();
}

class RasselFailCancelSubscriptionState extends RasselState{
  const RasselFailCancelSubscriptionState();
}

class RasselSubscribeState extends RasselState {
  Subscribe subscribe;

  RasselSubscribeState(this.subscribe);
}

class NetworkError extends RasselState {
  final String message;

  const NetworkError(this.message);
}

class ErrorState extends RasselState {
  final String message;

  const ErrorState(this.message);
}
