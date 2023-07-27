import 'package:o7therapy/api/api_manager.dart';
import 'package:o7therapy/api/models/my_subscriptions/cancel_subscription_wrapper.dart';
import 'package:o7therapy/api/models/my_subscriptions/my_subscriptions_wrapper.dart';
import 'package:o7therapy/ui/screens/my-subscriptions/bloc/my_subscriptions_bloc.dart';
import '../../../../api/errors/network_exceptions.dart';
abstract class BaseMySubscriptionsRepo {
  const BaseMySubscriptionsRepo();

  Future<MySubscriptionsState> getMySubscriptionsInfo();
}

class MySubscriptionsRepo extends BaseMySubscriptionsRepo {
  const MySubscriptionsRepo();

  @override
  Future<MySubscriptionsState> getMySubscriptionsInfo() async {
    late MySubscriptionsState state;
    try {
      await ApiManager.getMySubscriptions(
        success: (MySubscriptionsWrapper mySubscriptionsWrapper) async {
          state = LoadedMySubscriptionsState(mySubscriptionWrapper: mySubscriptionsWrapper);
        },
        fail: (NetworkExceptions details) {
          state = ExceptionMySubscriptionsState(
              details.errorMsg ?? "Oops... Something went wrong!");
        },
      );
    } catch (error) {
      state = const ExceptionMySubscriptionsState("Oops... Something went wrong!");
    }
    return state;
  }
  @override
  Future<MySubscriptionsState> cancelMySubscription() async {
    late MySubscriptionsState state;
    try {
      await ApiManager.cancelMySubscriptions(
        success: (CancelSubscriptionWrapper cancelSubscriptionWrapper) async {
          state = SuccessCancelSubscriptionsState(cancelSubscriptionWrapper: cancelSubscriptionWrapper);
        },
        fail: (NetworkExceptions details) {
          state = ExceptionMySubscriptionsState(
              details.errorMsg ?? "Oops... Something went wrong!");
        },
      );
    } catch (error) {
      state = const ExceptionMySubscriptionsState("Oops... Something went wrong!");
    }
    return state;
  }

}
