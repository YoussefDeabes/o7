import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:o7therapy/api/models/my_subscriptions/cancel_subscription_wrapper.dart';
import 'package:o7therapy/api/models/my_subscriptions/my_subscriptions_wrapper.dart';
import 'package:o7therapy/ui/screens/my-subscriptions/bloc/my_subscriptions_repo.dart';

part 'my_subscriptions_event.dart';
part 'my_subscriptions_state.dart';

class MySubscriptionsBloc extends Bloc<MySubscriptionsEvent, MySubscriptionsState> {
  MySubscriptionsBloc() : super(MySubscriptionsInitial()) {
    on<MySubscriptionsEvent>(_onGetMySubscriptions);
    on<CancelSubscriptionsEvent>(_onCancelSubscription);
  }
  _onGetMySubscriptions(event, emit) async {
    emit(const LoadingMySubscriptionsState());
    emit(await const MySubscriptionsRepo().getMySubscriptionsInfo());
  }
  _onCancelSubscription(event, emit) async {
    emit(const LoadingCancelSubscriptionsState());
    emit(await const MySubscriptionsRepo().cancelMySubscription());
  }

}
