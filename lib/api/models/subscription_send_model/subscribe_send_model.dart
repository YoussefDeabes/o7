class SubscribeSendModel {
  int? subscriptionId;
  int? serviceType;
  int? currency;
  int? clientType;

  SubscribeSendModel({
    this.subscriptionId,
    this.serviceType = 4,
    this.currency,
    this.clientType
  });

  Map toMap() {
    return {
      "subscription_id": subscriptionId,
      "service_type": 4,
      "currency": currency,
      "client_type": clientType
    };
  }
}
