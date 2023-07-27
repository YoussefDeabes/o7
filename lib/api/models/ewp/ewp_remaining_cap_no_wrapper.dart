class EwpRemainingCapNoWrapper {
  EwpRemainingCapNoWrapper({
    required this.data,
    required this.errorCode,
    required this.errorMsg,
    required this.errorDetails,
    required this.expiration,
    required this.persistence,
    required this.totalSeconds,
  });

  final Data? data;
  final int? errorCode;
  final String? errorMsg;
  final String? errorDetails;
  final Expiration? expiration;
  final Persistence? persistence;
  final int? totalSeconds;

  factory EwpRemainingCapNoWrapper.fromJson(json) => EwpRemainingCapNoWrapper(
        data: Data.fromJson(json["data"]),
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

class Data {
  Data({
    required this.remainingCap,
    required this.validTill,
    required this.orginalCap,
    required this.discountAmount,
    required this.corporateName,
  });

  final int? remainingCap;
  final DateTime? validTill;
  final int? orginalCap;
  final double? discountAmount;
  final String? corporateName;

  factory Data.fromJson(json) => Data(
        remainingCap: json["remaining_cap"],
        validTill: DateTime.parse(json["valid_till"]),
        orginalCap: json["orginal_cap"],
        discountAmount: json["discount_amount"],
        corporateName: json["corporate_name"],
      );

  Map<String, dynamic> toJson() => {
        "remaining_cap": remainingCap,
        "valid_till": validTill?.toIso8601String(),
        "orginal_cap": orginalCap,
        "discount_amount": discountAmount,
        "corporate_name": corporateName,
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

  final int? scope;
  final bool? isEncrypted;

  factory Persistence.fromJson(json) => Persistence(
        scope: json["scope"],
        isEncrypted: json["is_encrypted"],
      );

  Map<String, dynamic> toJson() => {
        "scope": scope,
        "is_encrypted": isEncrypted,
      };
}
