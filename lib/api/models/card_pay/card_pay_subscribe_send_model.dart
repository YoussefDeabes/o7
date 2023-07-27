import 'package:o7therapy/api/fort_constants.dart';

class CardPaySubscribeSendModel {
  String? cardCode;
  String? subscriptionId;
  String? customerIp;
  String? operationName = FortConstants.merchantExtraRasselSubscribe;

  CardPaySubscribeSendModel(
      {this.cardCode, this.subscriptionId, this.customerIp});

  Map toMap() {
    return {
      "card_code": cardCode,
      "client_subscription_id": subscriptionId,
      "operation_name": operationName,
      "customer_ip": customerIp
    };
  }
}
