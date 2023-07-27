class ResendVerificationCodeForInsuranceModel {
  ResendVerificationCodeForInsuranceModel({
    required this.data,
    required this.errorCode,
    required this.errorMsg,
    required this.errorDetails,
    required this.totalSeconds,
  });

  final bool? data;
  final int? errorCode;
  final String? errorMsg;
  final String? errorDetails;
  final int? totalSeconds;

  factory ResendVerificationCodeForInsuranceModel.fromJson(json) =>
      ResendVerificationCodeForInsuranceModel(
        data: json["data"],
        errorCode: json["error_code"],
        errorMsg: json["error_msg"],
        errorDetails: json["error_details"],
        totalSeconds: json["total_seconds"],
      );

  Map<String, dynamic> toJson() => {
        "data": data,
        "error_code": errorCode,
        "error_msg": errorMsg,
        "error_details": errorDetails,
        "total_seconds": totalSeconds,
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

  final bool isAllowed;
  final int duration;
  final int method;
  final int mode;
  final bool isSessionExpiry;

  factory Expiration.fromJson(json) => Expiration(
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

  final int scope;
  final bool isEncrypted;

  factory Persistence.fromJson(json) => Persistence(
        scope: json["scope"],
        isEncrypted: json["is_encrypted"],
      );

  Map<String, dynamic> toJson() => {
        "scope": scope,
        "is_encrypted": isEncrypted,
      };
}
