
class CancelSubscriptionWrapper {
  CancelSubscriptionWrapper({
    required this.data,
    required this.errorCode,
    required this.errorMsg,
    required this.errorDetails,
    required this.expiration,
    required this.persistence,
    required this.totalSeconds,
  });

  final CancelSubscriptionInfo? data;
  final int? errorCode;
  final String? errorMsg;
  final String? errorDetails;
  final Expiration? expiration;
  final Persistence? persistence;
  final int? totalSeconds;

  factory CancelSubscriptionWrapper.fromJson(Map<String, dynamic> json) =>
      CancelSubscriptionWrapper(
        data: json["data"] != null
            ? CancelSubscriptionInfo.fromJson(json["data"])
            : null,
        errorCode: json["error_code"],
        errorMsg: json["error_msg"],
        errorDetails: json["error_details"],
        expiration: json['expiration'] != null
            ? Expiration.fromJson(json['expiration'])
            : null,
        persistence: json['persistence'] != null
            ? Persistence.fromJson(json['persistence'])
            : null,
        totalSeconds: json["total_seconds"],
      );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "error_code": errorCode,
    "error_msg": errorMsg,
    "error_details": errorDetails,
    "expiration": expiration?.toJson(),
    "persistence": persistence?.toJson(),
    "total_seconds": totalSeconds,
  };
}

class CancelSubscriptionInfo {
  CancelSubscriptionInfo(
      );


  factory CancelSubscriptionInfo.fromJson(Map<String, dynamic> json) =>
      CancelSubscriptionInfo(
      );

  Map<String, dynamic> toJson() => {
  };
}

class Expiration {
  Expiration({
    required this.isAllowed,
    required this.duration,
    required this.method,
    required this.mode,
    required this.isSessionExpiry,
  });

  final bool? isAllowed;
  final int? duration;
  final int? method;
  final int? mode;
  final bool? isSessionExpiry;

  factory Expiration.fromJson(Map<String, dynamic> json) => Expiration(
    isAllowed: json["is_allowed"],
    duration: json["duration"],
    method: json["method"],
    mode: json["mode"],
    isSessionExpiry: json["is_session_expiry"],
  );

  Map<String, dynamic> toJson() => {
    "is_allowed": isAllowed,
    "duration": duration,
    "method": method,
    "mode": mode,
    "is_session_expiry": isSessionExpiry,
  };
}

class Persistence {
  Persistence({
    required this.scope,
    required this.isEncrypted,
  });

  final int? scope;
  final bool? isEncrypted;

  factory Persistence.fromJson(Map<String, dynamic> json) => Persistence(
    scope: json["scope"],
    isEncrypted: json["is_encrypted"],
  );

  Map<String, dynamic> toJson() => {
    "scope": scope,
    "is_encrypted": isEncrypted,
  };
}
