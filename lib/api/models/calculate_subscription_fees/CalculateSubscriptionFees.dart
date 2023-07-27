import 'Data.dart';
import 'Expiration.dart';
import 'Persistence.dart';

/// data : {"currency":"EGP","subscription_fees":0.0,"patient_id":null,"discount_source":1,"discount_amount":280.00,"discount_precentage":0.0,"id":0.0,"name":"","subscription_id":2}
/// error_code : 0
/// error_msg : ""
/// error_details : ""
/// expiration : {"is_allowed":false,"duration":0,"method":0,"mode":0,"is_session_expiry":false}
/// persistence : {"scope":0,"is_encrypted":false}
/// total_seconds : 0

class CalculateSubscriptionFees {
  CalculateSubscriptionFees({
      this.data, 
      this.errorCode, 
      this.errorMsg, 
      this.errorDetails, 
      this.expiration, 
      this.persistence, 
      this.totalSeconds,});

  CalculateSubscriptionFees.fromJson(dynamic json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    errorCode = json['error_code'];
    errorMsg = json['error_msg'];
    errorDetails = json['error_details'];
    expiration = json['expiration'] != null ? Expiration.fromJson(json['expiration']) : null;
    persistence = json['persistence'] != null ? Persistence.fromJson(json['persistence']) : null;
    totalSeconds = json['total_seconds'];
  }
  Data? data;
  num? errorCode;
  String? errorMsg;
  String? errorDetails;
  Expiration? expiration;
  Persistence? persistence;
  num? totalSeconds;
CalculateSubscriptionFees copyWith({  Data? data,
  num? errorCode,
  String? errorMsg,
  String? errorDetails,
  Expiration? expiration,
  Persistence? persistence,
  num? totalSeconds,
}) => CalculateSubscriptionFees(  data: data ?? this.data,
  errorCode: errorCode ?? this.errorCode,
  errorMsg: errorMsg ?? this.errorMsg,
  errorDetails: errorDetails ?? this.errorDetails,
  expiration: expiration ?? this.expiration,
  persistence: persistence ?? this.persistence,
  totalSeconds: totalSeconds ?? this.totalSeconds,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['error_code'] = errorCode;
    map['error_msg'] = errorMsg;
    map['error_details'] = errorDetails;
    if (expiration != null) {
      map['expiration'] = expiration?.toJson();
    }
    if (persistence != null) {
      map['persistence'] = persistence?.toJson();
    }
    map['total_seconds'] = totalSeconds;
    return map;
  }

}