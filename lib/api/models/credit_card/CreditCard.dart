import 'Data.dart';
import 'Expiration.dart';
import 'Persistence.dart';

/// data : [{"last_four_digits":"1234","code":"CC-9207210530010112","brand":0,"is_deleted":true,"expiry_date":"20250501000000","is_preferred":false},{"last_four_digits":"5678","code":"CC-9207210530010112","brand":0,"is_deleted":true,"expiry_date":"20250501000000","is_preferred":false}]
/// error_code : 0
/// error_msg : ""
/// error_details : null
/// expiration : {"is_allowed":false,"duration":0,"method":0,"mode":0,"is_session_expiry":false}
/// persistence : {"scope":0,"is_encrypted":false}
/// total_seconds : 0

class CreditCard {
  CreditCard({
    this.data,
    this.errorCode,
    this.errorMsg,
    this.errorDetails,
    this.expiration,
    this.persistence,
    this.totalSeconds,
  });

  CreditCard.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(CreditCardData.fromJson(v));
      });
    }
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

  List<CreditCardData>? data;
  int? errorCode;
  String? errorMsg;
  dynamic errorDetails;
  Expiration? expiration;
  Persistence? persistence;
  int? totalSeconds;

  CreditCard copyWith({
    List<CreditCardData>? data,
    int? errorCode,
    String? errorMsg,
    dynamic errorDetails,
    Expiration? expiration,
    Persistence? persistence,
    int? totalSeconds,
  }) =>
      CreditCard(
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
      map['data'] = data?.map((v) => v.toJson()).toList();
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
