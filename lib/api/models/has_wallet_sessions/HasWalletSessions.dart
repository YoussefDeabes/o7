import 'Data.dart';
import 'Expiration.dart';
import 'Persistence.dart';

/// data : {"list":[{"therapist_id":"0e8d8019-5b1a-499c-92ea-a564550eeab6","therapist_name":"Zaina Hossam","therapist_profession":"En","therapist_image":{"image_code":"IMG_2021-06-14-10_44160.png","url":"/api/identity/imgapi/IMG_2021-06-14-10_44160.png"},"fees_per_session":6000.00,"fees_per_international_session":9000.00,"first_available_slot_date":null,"session_advance_notice_period":null,"currency":"EGP","patient_wallet":[{"id":19,"duration":50.00}]}],"total_count":1,"has_more":false}
/// error_code : 0
/// error_msg : ""
/// error_details : ""
/// expiration : {"is_allowed":false,"duration":0,"method":0,"mode":0,"is_session_expiry":false}
/// persistence : {"scope":0,"is_encrypted":false}
/// total_seconds : 0

class HasWalletSessions {
  HasWalletSessions({
      this.data, 
      this.errorCode, 
      this.errorMsg, 
      this.errorDetails, 
      this.expiration, 
      this.persistence, 
      this.totalSeconds,});

  HasWalletSessions.fromJson(dynamic json) {
    data = json['data'] != null ? WalletSessionsData.fromJson(json['data']) : null;
    errorCode = json['error_code'];
    errorMsg = json['error_msg'];
    errorDetails = json['error_details'];
    expiration = json['expiration'] != null ? Expiration.fromJson(json['expiration']) : null;
    persistence = json['persistence'] != null ? Persistence.fromJson(json['persistence']) : null;
    totalSeconds = json['total_seconds'];
  }
  WalletSessionsData? data;
  int? errorCode;
  String? errorMsg;
  String? errorDetails;
  Expiration? expiration;
  Persistence? persistence;
  int? totalSeconds;
HasWalletSessions copyWith({  WalletSessionsData? data,
  int? errorCode,
  String? errorMsg,
  String? errorDetails,
  Expiration? expiration,
  Persistence? persistence,
  int? totalSeconds,
}) => HasWalletSessions(  data: data ?? this.data,
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