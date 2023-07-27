import 'Data.dart';
import 'Expiration.dart';
import 'Persistence.dart';

/// data : {"original_fees_amount":100.0,"new_fees_amount":5.000,"discount_amount":95.000,"discount_percentage":95.00,"currency":"EGP"}
/// error_code : 0
/// error_msg : ""
/// error_details : ""
/// expiration : {"is_allowed":false,"duration":0,"method":0,"mode":0,"is_session_expiry":false}
/// persistence : {"scope":0,"is_encrypted":false}
/// total_seconds : 0

class PromoCode {
  PromoCode({
    this.data,
    this.errorCode,
    this.errorMsg,
    this.errorDetails,
    this.expiration,
    this.persistence,
    this.totalSeconds,
  });

  PromoCode.fromJson(dynamic json) {
    data = json['data'] != null ? PromoCodeData.fromJson(json['data']) : null;
    errorCode = json['error_code'];
    errorMsg = json['error_msg'];
    errorDetails = json['error_details'];
    expiration = json['expiration'] != null
        ? Expiration.fromJson(json['expiration'])
        : null;
    persistence = json['persistence'] != null
        ? Persistence.fromJson(json['persistence'])
        : null;
    totalSeconds = json['total_seconds'];
  }

  PromoCodeData? data;
  int? errorCode;
  String? errorMsg;
  String? errorDetails;
  Expiration? expiration;
  Persistence? persistence;
  int? totalSeconds;

  PromoCode copyWith({
    PromoCodeData? data,
    int? errorCode,
    String? errorMsg,
    String? errorDetails,
    Expiration? expiration,
    Persistence? persistence,
    int? totalSeconds,
  }) =>
      PromoCode(
        data: data ?? this.data,
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
