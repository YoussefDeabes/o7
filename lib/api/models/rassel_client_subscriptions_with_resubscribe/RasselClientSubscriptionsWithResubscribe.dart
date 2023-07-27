import 'Data.dart';
import 'Expiration.dart';
import 'Persistence.dart';

/// data : {"id":50,"client_id":"c2d1f815-e39a-4f42-89cd-9eaa9f3370c6","subscription_id":2,"subscroption_name":"Rasel Subscription","status":3,"is_active":false,"corporate_id":2,"is_poromotion":true,"paid_fees":175.00,"corporate_name":"dd","next_payment_amount":350.00,"next_payment_date":"2024-01-10T09:13:09.8270964","currency":"EGP"}
/// error_code : 0
/// error_msg : ""
/// error_details : ""
/// expiration : {"is_allowed":false,"duration":0,"method":0,"mode":0,"is_session_expiry":false}
/// persistence : {"scope":0,"is_encrypted":false}
/// total_seconds : 0

class RasselClientSubscriptionsWithResubscribe {
  RasselClientSubscriptionsWithResubscribe({
      this.data, 
      this.errorCode, 
      this.errorMsg, 
      this.errorDetails, 
      this.expiration, 
      this.persistence, 
      this.totalSeconds,});

  RasselClientSubscriptionsWithResubscribe.fromJson(dynamic json) {
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
RasselClientSubscriptionsWithResubscribe copyWith({  Data? data,
  num? errorCode,
  String? errorMsg,
  String? errorDetails,
  Expiration? expiration,
  Persistence? persistence,
  num? totalSeconds,
}) => RasselClientSubscriptionsWithResubscribe(  data: data ?? this.data,
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