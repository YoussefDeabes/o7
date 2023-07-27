part of 'rassel_checkout_bloc.dart';

@immutable
abstract class RasselCheckoutState {
  const RasselCheckoutState();
}

class RasselCheckoutInitial extends RasselCheckoutState {}
class RasselLoadingState extends RasselCheckoutState {}

class RasselCheckoutSubscribeState extends RasselCheckoutState {
  RasselSubscription rasselSubscription;
  RasselCheckoutSubscribeState({required this.rasselSubscription});
}

class RasselCalculateSubscriptionFeesState extends RasselCheckoutState {
  CalculateSubscriptionFees calculateSubscriptionFees;
  num? subscriptionId;

  RasselCalculateSubscriptionFeesState(this.calculateSubscriptionFees,this.subscriptionId);
}

class SubscribeRasselSuccess extends RasselCheckoutState {
  final Subscribe subscribe;
  final String token;
  final String ip;
  final String userId;
  final String countryCode;

  const SubscribeRasselSuccess(this.subscribe, this.token, this.ip,this.countryCode,this.userId);
}
class NetworkError extends RasselCheckoutState {
  final String message;

  const NetworkError(this.message);
}

class ErrorState extends RasselCheckoutState {
  final String message;

  const ErrorState(this.message);
}
