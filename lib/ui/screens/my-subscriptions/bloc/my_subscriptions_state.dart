part of 'my_subscriptions_bloc.dart';


abstract class MySubscriptionsState extends Equatable {
  const MySubscriptionsState();
  @override
  List<Object> get props => [];
}
class MySubscriptionsInitial extends MySubscriptionsState {}

class LoadingMySubscriptionsState extends MySubscriptionsState {
  const LoadingMySubscriptionsState();
}

class LoadedMySubscriptionsState extends MySubscriptionsState {
  final MySubscriptionsWrapper mySubscriptionWrapper;
  const LoadedMySubscriptionsState({required this.mySubscriptionWrapper});
}

class ExceptionMySubscriptionsState extends MySubscriptionsState {
  final String exception;

  const ExceptionMySubscriptionsState(this.exception);
}
class LoadingCancelSubscriptionsState extends MySubscriptionsState {
  const LoadingCancelSubscriptionsState();
}

class SuccessCancelSubscriptionsState extends MySubscriptionsState {
  final CancelSubscriptionWrapper cancelSubscriptionWrapper;
  const SuccessCancelSubscriptionsState({required this.cancelSubscriptionWrapper});
}

class ExceptionCancelSubscriptionsState extends MySubscriptionsState {
  final String exception;

  const ExceptionCancelSubscriptionsState(this.exception);
}