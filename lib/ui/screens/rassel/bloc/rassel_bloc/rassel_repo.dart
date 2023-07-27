import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/models/calculate_subscription_fees/CalculateSubscriptionFees.dart';
import 'package:o7therapy/api/models/calculate_subscription_send_model/calculate_subscription_send_model.dart';
import 'package:o7therapy/api/models/cancel_subscription/CancelSubscription.dart';
import 'package:o7therapy/api/models/rassel_client_subscription/RasselClientSubscriptions.dart';
import 'package:o7therapy/api/models/rassel_client_subscriptions_with_resubscribe/RasselClientSubscriptionsWithResubscribe.dart';
import 'package:o7therapy/api/models/rassel_is_subscribed/IsSubscribed.dart';
import 'package:o7therapy/api/models/rassel_subscription/RasselSubscription.dart';
import 'package:o7therapy/api/models/subscribe/Subscribe.dart';
import 'package:o7therapy/api/models/subscription_send_model/subscribe_send_model.dart';
import 'package:o7therapy/api/rassel_api_manager.dart';
import 'package:o7therapy/ui/screens/rassel/bloc/rassel_bloc/rassel_bloc.dart';
import 'package:o7therapy/util/secure_storage_helper/secure_storage.dart';

abstract class BaseRasselRepo {
  const BaseRasselRepo();

  Future<RasselState> getRasselSubscription();

  Future<RasselState> getIsSubscribed(
      {required String subscriptionId,
      required num amount,
      required num currency});

  // Future<RasselState> getRasselClientSubscriptions();
  Future<RasselState> getRasselClientSubscriptionsWithResubscribe();

  Future<RasselState> calculateSubscriptionFees(
      {required CalculateSubscriptionSendModel subscribeModel});

  Future<RasselState> cancelSubscription(
      {required String clientSubscriptionId});

  Future<RasselState> subscribe(
      {required SubscribeSendModel subscribeSendModel});
}

class RasselRepo extends BaseRasselRepo {
  const RasselRepo();

  @override
  Future<RasselState> getRasselSubscription() async {
    RasselState? rasselState;
    NetworkExceptions? detailsModel;
    try {
      await RasselApiManager.getRasselSubscription(
        (RasselSubscription rasselSubscription) async{
          rasselState =
              RasselSubscriptionState(rasselSubscription: rasselSubscription);
          await SecureStorage.setHasActiveRasselSubscription((rasselSubscription.data?.hasActiveSubscription??"false").toString());
        }, (NetworkExceptions details) {
        detailsModel = details;
        rasselState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      rasselState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return rasselState!;
  }

  @override
  Future<RasselState> getIsSubscribed(
      {required String subscriptionId,
      required num amount,
      required num currency}) async {
    RasselState? rasselState;
    NetworkExceptions? detailsModel;
    try {
      await RasselApiManager.isSubscribed(
        subscriptionId: subscriptionId,
        (IsSubscribed isSubscribed) {
          if (isSubscribed.data == true) {
            rasselState = RasselSubscribedState();
          } else {
            rasselState =
                RasselNotSubscribedState(amount: amount, currency: currency);
          }
        }, (NetworkExceptions details) {
        detailsModel = details;
        rasselState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      rasselState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return rasselState!;
  }

  // @override
  // Future<RasselState> getRasselClientSubscriptions() async {
  //   RasselState? rasselState;
  //   NetworkExceptions? detailsModel;
  //   try {
  //     await RasselApiManager.getRasselClientSubscriptions(
  //       (RasselClientSubscriptions rasselClientSubscriptions) {
  //         rasselState =
  //             RasselClientSubscriptionState(rasselClientSubscriptions);
  //       },
  //       (NetworkExceptions details) {
  //         rasselState = NetworkError(details.errorMsg!);
  //       },
  //     );
  //   } catch (error) {
  //     rasselState = ErrorState(detailsModel?.errorMsg ?? error.toString());
  //   }
  //   return rasselState!;
  // }
  @override
  Future<RasselState> getRasselClientSubscriptionsWithResubscribe() async {
    RasselState? rasselState;
    NetworkExceptions? detailsModel;
    try {
      await RasselApiManager.getRasselClientSubscriptionsWithResubscribe(
        (RasselClientSubscriptionsWithResubscribe rasselClientSubscriptions) {
          rasselState =
              RasselClientSubscriptionState(rasselClientSubscriptions);
        }, (NetworkExceptions details) {
        detailsModel = details;
        rasselState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      rasselState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return rasselState!;
  }

  @override
  Future<RasselState> calculateSubscriptionFees(
      {required CalculateSubscriptionSendModel subscribeModel}) async {
    RasselState? rasselState;
    NetworkExceptions? detailsModel;
    try {
      await RasselApiManager.calculateSubscriptionFees(
        model: subscribeModel,
        (CalculateSubscriptionFees calculateSubscriptionFees) {
          rasselState =
              RasselCalculateSubscriptionFeesState(calculateSubscriptionFees);
        }, (NetworkExceptions details) {
        detailsModel = details;
        rasselState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      rasselState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return rasselState!;
  }

  @override
  Future<RasselState> cancelSubscription(
      {required String clientSubscriptionId}) async {
    RasselState? rasselState;
    NetworkExceptions? detailsModel;
    try {
      await RasselApiManager.cancelSubscription(
        clientSubscriptionId: clientSubscriptionId,
        (CancelSubscription cancelSubscription) {
          if (cancelSubscription.data == true) {
            rasselState = const RasselCancelSubscriptionState();
          } else {
            const RasselFailCancelSubscriptionState();
          }
        }, (NetworkExceptions details) {
        detailsModel = details;
        rasselState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      rasselState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return rasselState!;
  }

  @override
  Future<RasselState> subscribe(
      {required SubscribeSendModel subscribeSendModel}) async {
    RasselState? rasselState;
    NetworkExceptions? detailsModel;
    try {
      await RasselApiManager.subscribe(
        model: subscribeSendModel,
        (Subscribe subscribe) {
          rasselState = RasselSubscribeState(subscribe);
        }, (NetworkExceptions details) {
        detailsModel = details;
        rasselState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      rasselState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return rasselState!;
  }
}
