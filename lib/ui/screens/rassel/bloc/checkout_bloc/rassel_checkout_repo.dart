import 'package:dart_ipify/dart_ipify.dart';
import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/models/calculate_subscription_fees/CalculateSubscriptionFees.dart';
import 'package:o7therapy/api/models/calculate_subscription_send_model/calculate_subscription_send_model.dart';
import 'package:o7therapy/api/models/rassel_subscription/RasselSubscription.dart';
import 'package:o7therapy/api/models/subscribe/Subscribe.dart';
import 'package:o7therapy/api/models/subscription_send_model/subscribe_send_model.dart';
import 'package:o7therapy/api/rassel_api_manager.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/ui/screens/rassel/bloc/checkout_bloc/rassel_checkout_bloc.dart';

abstract class BaseRasselCheckoutRepo {
  const BaseRasselCheckoutRepo();

  Future<RasselCheckoutState> getRasselCheckout();

  Future<RasselCheckoutState> calculateSubscriptionFees(
      {required CalculateSubscriptionSendModel subscribeModel,
      required num? subscriptionId});

  Future<RasselCheckoutState> subscribeRassel(SubscribeSendModel model);
}

class RasselCheckoutRepo extends BaseRasselCheckoutRepo {
  const RasselCheckoutRepo();

  @override
  Future<RasselCheckoutState> getRasselCheckout() async {
    RasselCheckoutState? rasselState;
    NetworkExceptions? detailsModel;
    try {
      await RasselApiManager.getRasselSubscription(
          (RasselSubscription rasselSubscription) {
        rasselState = RasselCheckoutSubscribeState(
            rasselSubscription: rasselSubscription);
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
  Future<RasselCheckoutState> calculateSubscriptionFees(
      {required CalculateSubscriptionSendModel subscribeModel,
      required num? subscriptionId}) async {
    RasselCheckoutState? rasselState;
    NetworkExceptions? detailsModel;
    try {
      await RasselApiManager.calculateSubscriptionFees(model: subscribeModel,
          (CalculateSubscriptionFees calculateSubscriptionFees) {
        rasselState = RasselCalculateSubscriptionFeesState(
            calculateSubscriptionFees, subscriptionId);
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
  Future<RasselCheckoutState> subscribeRassel(SubscribeSendModel model) async {
    RasselCheckoutState? checkoutState;
    NetworkExceptions? detailsModel;
    final token = await PrefManager.getToken();
    final ipv4 = await Ipify.ipv4();
    String? id = await PrefManager.getId();
    String? countryCode = await PrefManager.getCountryCode();
    try {
      await RasselApiManager.subscribe(model: model, (Subscribe subscribe) {
        checkoutState =
            SubscribeRasselSuccess(subscribe, token!, ipv4, countryCode!, id!);
      }, (NetworkExceptions details) {
        detailsModel = details;
        checkoutState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      checkoutState = ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return checkoutState!;
  }
}
