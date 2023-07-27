import 'data.dart';
import 'expiration.dart';
import 'persistence.dart';

class TherapistListWrapper {
  TherapistListWrapper({
    this.data,
    this.errorCode,
    this.errorMsg,
    this.errorDetails,
    this.expiration,
    this.persistence,
    this.totalSeconds,
  });

  TherapistListWrapper.fromJson(dynamic json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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
  Data? data;
  int? errorCode;
  String? errorMsg;
  String? errorDetails;
  Expiration? expiration;
  Persistence? persistence;
  int? totalSeconds;
  TherapistListWrapper copyWith({
    Data? data,
    int? errorCode,
    String? errorMsg,
    String? errorDetails,
    Expiration? expiration,
    Persistence? persistence,
    int? totalSeconds,
  }) =>
      TherapistListWrapper(
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
