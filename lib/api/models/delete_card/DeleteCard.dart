import 'Expiration.dart';
import 'Persistence.dart';

/// error_code : 0
/// error_msg : ""
/// error_details : null
/// expiration : {"is_allowed":false,"duration":0,"method":0,"mode":0,"is_session_expiry":false}
/// persistence : {"scope":0,"is_encrypted":false}
/// total_seconds : 0

class DeleteCard {
  DeleteCard({
      this.errorCode, 
      this.errorMsg, 
      this.errorDetails, 
      this.expiration, 
      this.persistence, 
      this.totalSeconds,});

  DeleteCard.fromJson(dynamic json) {
    errorCode = json['error_code'];
    errorMsg = json['error_msg'];
    errorDetails = json['error_details'];
    expiration = json['expiration'] != null ? Expiration.fromJson(json['expiration']) : null;
    persistence = json['persistence'] != null ? Persistence.fromJson(json['persistence']) : null;
    totalSeconds = json['total_seconds'];
  }
  int? errorCode;
  String? errorMsg;
  dynamic errorDetails;
  Expiration? expiration;
  Persistence? persistence;
  int? totalSeconds;
DeleteCard copyWith({  int? errorCode,
  String? errorMsg,
  dynamic errorDetails,
  Expiration? expiration,
  Persistence? persistence,
  int? totalSeconds,
}) => DeleteCard(  errorCode: errorCode ?? this.errorCode,
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