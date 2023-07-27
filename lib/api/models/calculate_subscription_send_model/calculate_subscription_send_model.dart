import 'package:o7therapy/prefs/pref_keys.dart';
import 'package:o7therapy/prefs/pref_manager.dart';

class CalculateSubscriptionSendModel {
  int? subscriptionId;
  int? serviceType;
  int? currency;
  String? clientId;
  String? clientEmail;
  int? clientType;
  String? companyCode;

  CalculateSubscriptionSendModel({
    this.subscriptionId,
    this.serviceType = 4,
    this.currency,
    this.clientId,
    this.clientEmail,
    this.clientType,
    this.companyCode
  });

  Map toMap() {
    return {
      "subscription_id": subscriptionId,
      "service_type": 4,
      "currency": currency,
    "client_id":clientId,
    "client_email":clientEmail,
      "company_code": companyCode,
      "client_type" :clientType,
      "promo_code":null,
    };
  }
}
