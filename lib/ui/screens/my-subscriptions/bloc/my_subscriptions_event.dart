part of 'my_subscriptions_bloc.dart';


abstract class MySubscriptionsEvent extends Equatable {
  const MySubscriptionsEvent();

  @override
  List<Object?> get props => [];
}

class GetMySubscriptionsEvent extends MySubscriptionsEvent {
  const GetMySubscriptionsEvent();
}
class CancelSubscriptionsEvent extends MySubscriptionsEvent {
  const CancelSubscriptionsEvent();
}
