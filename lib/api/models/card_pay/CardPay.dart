/// error_code : 1
/// error_msg : "Currency not accepted by acquirer"
/// error_details : null
/// expiration : null
/// persistence : null
/// total_seconds : 0

class CardPay {
  CardPay({
      this.errorCode, 
      this.errorMsg, 
      this.errorDetails, 
      this.expiration, 
      this.persistence, 
      this.totalSeconds,});

  CardPay.fromJson(dynamic json) {
    errorCode = json['error_code'];
    errorMsg = json['error_msg'];
    errorDetails = json['error_details'];
    expiration = json['expiration'];
    persistence = json['persistence'];
    totalSeconds = json['total_seconds'];
  }
  int? errorCode;
  String? errorMsg;
  dynamic errorDetails;
  dynamic expiration;
  dynamic persistence;
  int? totalSeconds;
CardPay copyWith({  int? errorCode,
  String? errorMsg,
  dynamic errorDetails,
  dynamic expiration,
  dynamic persistence,
  int? totalSeconds,
}) => CardPay(  errorCode: errorCode ?? this.errorCode,
  errorMsg: errorMsg ?? this.errorMsg,
  errorDetails: errorDetails ?? this.errorDetails,
  expiration: expiration ?? this.expiration,
  persistence: persistence ?? this.persistence,
  totalSeconds: totalSeconds ?? this.totalSeconds,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error_code'] = errorCode;
    map['error_msg'] = errorMsg;
    map['error_details'] = errorDetails;
    map['expiration'] = expiration;
    map['persistence'] = persistence;
    map['total_seconds'] = totalSeconds;
    return map;
  }

}