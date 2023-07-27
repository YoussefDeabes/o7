import 'package:o7therapy/api/models/calculate_subscription_fees/CalculateSubscriptionFees.dart';
import 'package:o7therapy/api/models/calculate_subscription_send_model/calculate_subscription_send_model.dart';
import 'package:o7therapy/api/models/cancel_subscription/CancelSubscription.dart';
import 'package:o7therapy/api/models/rassel_client_subscription/RasselClientSubscriptions.dart';
import 'package:o7therapy/api/models/rassel_client_subscriptions_with_resubscribe/RasselClientSubscriptionsWithResubscribe.dart';
import 'package:o7therapy/api/models/rassel_is_subscribed/IsSubscribed.dart';
import 'package:o7therapy/api/models/rassel_subscription/RasselSubscription.dart';
import 'package:o7therapy/api/models/subscribe/Subscribe.dart';
import 'package:o7therapy/api/models/subscription_send_model/subscribe_send_model.dart';

import 'api_keys.dart';
import 'base/base_api_manager.dart';
import 'errors/network_exceptions.dart';

class RasselApiManager {
  static Future<void> getRasselSubscription(
      void Function(RasselSubscription) success,
      void Function(NetworkExceptions) fail) async {
    await BaseApi.updateHeader();
    await BaseApi.dio.get(ApiKeys.getRasselSubscription).then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      RasselSubscription wrapper = RasselSubscription.fromJson(extractedData);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    }).catchError((onError) {
      fail(NetworkExceptions.getDioException(onError));
    });
  }

  static Future<void> isSubscribed(void Function(IsSubscribed) success,
      void Function(NetworkExceptions) fail,
      {required String subscriptionId}) async {
    await BaseApi.updateHeader();
    await BaseApi.dio
        .get(ApiKeys.getIsSubscribedQuery(subscriptionId: subscriptionId))
        .then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      IsSubscribed wrapper = IsSubscribed.fromJson(extractedData);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    }).catchError((onError) {
      fail(NetworkExceptions.getDioException(onError));
    });
  }

  static Future<void> getRasselClientSubscriptions(
      void Function(RasselClientSubscriptions) success,
      void Function(NetworkExceptions) fail) async {
    await BaseApi.updateHeader();
    await BaseApi.dio.get(ApiKeys.getRasselClientSubscription).then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      RasselClientSubscriptions wrapper =
          RasselClientSubscriptions.fromJson(extractedData);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    }).catchError((onError) {
      fail(NetworkExceptions.getDioException(onError));
    });
  }

  static Future<void> getRasselClientSubscriptionsWithResubscribe(
      void Function(RasselClientSubscriptionsWithResubscribe) success,
      void Function(NetworkExceptions) fail) async {
    await BaseApi.updateHeader();
    await BaseApi.dio.get(ApiKeys.getRasselClientSubscriptionWithResibscribe).then((response) {
      Map<String, dynamic> extractedData =
      response.data as Map<String, dynamic>;
      RasselClientSubscriptionsWithResubscribe wrapper =
      RasselClientSubscriptionsWithResubscribe.fromJson(extractedData);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    }).catchError((onError) {
      fail(NetworkExceptions.getDioException(onError));
    });
  }

  //todo: Add cancel subscription model
  static Future<void> cancelSubscription(void Function(CancelSubscription) success,
      void Function(NetworkExceptions) fail,
      {required String clientSubscriptionId}) async {
    await BaseApi.updateHeader();
    await BaseApi.dio
        .post(ApiKeys.getCancelSubscriptionQuery(
            clientSubscriptionId: clientSubscriptionId))
        .then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      CancelSubscription wrapper = CancelSubscription.fromJson(extractedData);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    }).catchError((onError) {
      fail(NetworkExceptions.getDioException(onError));
    });
  }

  static Future<void> calculateSubscriptionFees(
      void Function(CalculateSubscriptionFees) success,
      void Function(NetworkExceptions) fail,
      {required CalculateSubscriptionSendModel model}) async {
    await BaseApi.updateHeader();
    await BaseApi.dio
        .post(ApiKeys.calculateSubscriptionFees, data: model.toMap())
        .then((response) {
      print('-------------------------------');
          print(response.data);
          print(response.statusCode);
          print('-------------------------------');
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      CalculateSubscriptionFees wrapper =
          CalculateSubscriptionFees.fromJson(extractedData);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    }).catchError((onError) {
      fail(NetworkExceptions.getDioException(onError));
    });
  }

  static Future<void> subscribe(
      void Function(Subscribe) success, void Function(NetworkExceptions) fail,
      {required SubscribeSendModel model}) async {
    await BaseApi.updateHeader();
    await BaseApi.dio
        .post(ApiKeys.rasselSubscribe, data: model.toMap())
        .then((response) {
      Map<String, dynamic> extractedData =
          response.data as Map<String, dynamic>;
      Subscribe wrapper = Subscribe.fromJson(extractedData);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    }).catchError((onError) {
      fail(NetworkExceptions.getDioException(onError));
    });
  }
}
