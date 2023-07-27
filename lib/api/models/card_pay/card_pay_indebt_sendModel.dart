import 'package:o7therapy/api/fort_constants.dart';

class CardPaySendModel {
  String? cardCode;
  String? sessionId;
  String? customerIp;
  String? returnUrl;
  String? operationName = FortConstants.merchantExtra;

  CardPaySendModel({this.cardCode, this.sessionId, this.customerIp});

  Map toMap() {
    return {
      "card_code": cardCode,
      "session_id": sessionId,
      "operation_name": operationName,
      "customer_ip": customerIp,
      "return_url": returnUrl
    };
  }
}
