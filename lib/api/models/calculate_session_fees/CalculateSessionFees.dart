import 'Data.dart';
import 'Expiration.dart';
import 'Persistence.dart';

/// data : {"refund_amount":50.00,"flat_rate":false,"fees_amount":0.00,"fees_percentage":0.0,"currency":"EGP"}
/// error_code : 0
/// error_msg : ""
/// error_details : ""
/// expiration : {"is_allowed":false,"duration":0,"method":0,"mode":0,"is_session_expiry":false}
/// persistence : {"scope":0,"is_encrypted":false}
/// total_seconds : 0

class CalculateSessionFees {
  CalculateSessionFees({
      this.data, 
      this.errorCode, 
      this.errorMsg, 
      this.errorDetails, 
      this.expiration, 
      this.persistence, 
      this.totalSeconds,});

  CalculateSessionFees.fromJson(dynamic json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    errorCode = json['error_code'];
    errorMsg = json['error_msg'];
    errorDetails = json['error_details'];
    expiration = json['expiration'] != null ? Expiration.fromJson(json['expiration']) : null;
    persistence = json['persistence'] != null ? Persistence.fromJson(json['persistence']) : null;
    totalSeconds = json['total_seconds'];
  }
  Data? data;
  int? errorCode;
  String? errorMsg;
  String? errorDetails;
  Expiration? expiration;
  Persistence? persistence;
  int? totalSeconds;
CalculateSessionFees copyWith({  Data? data,
  int? errorCode,
  String? errorMsg,
  String? errorDetails,
  Expiration? expiration,
  Persistence? persistence,
  int? totalSeconds,
}) => CalculateSessionFees(  data: data ?? this.data,
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