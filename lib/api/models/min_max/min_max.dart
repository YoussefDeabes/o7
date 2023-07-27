import 'dart:convert';

class MinMaxWrapper {
  MinMaxWrapper({
    required this.data,
    required this.errorCode,
    required this.errorMsg,
    required this.errorDetails,
    required this.expiration,
    required this.persistence,
    required this.totalSeconds,
  });

  final Data data;
  final int errorCode;
  final String errorMsg;
  final String errorDetails;
  final Expiration expiration;
  final Persistence persistence;
  final int totalSeconds;

  factory MinMaxWrapper.fromJson(String str) =>
      MinMaxWrapper.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MinMaxWrapper.fromMap(json) => MinMaxWrapper(
        data: Data.fromMap(json["data"]),
        errorCode: json["error_code"] ?? "",
        errorMsg: json["error_msg"] ?? "",
        errorDetails: json["error_details"] ?? "",
        expiration: Expiration.fromMap(json["expiration"]),
        persistence: Persistence.fromMap(json["persistence"]),
        totalSeconds: json["total_seconds"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "data": data.toMap(),
        "error_code": errorCode,
        "error_msg": errorMsg,
        "error_details": errorDetails,
        "expiration": expiration.toMap(),
        "persistence": persistence.toMap(),
        "total_seconds": totalSeconds,
      };
}

class Data {
  Data({
    required this.minValue,
    required this.maxValue,
    required this.currency,
  });

  final int minValue;
  final int maxValue;
  final String currency;

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(json) => Data(
        minValue: json["min_value"] ?? 0,
        maxValue: json["max_value"] ?? 0,
        currency: json["currency"] ?? "USD",
      );

  Map<String, dynamic> toMap() => {
        "min_value": minValue,
        "max_value": maxValue,
        "currency": currency,
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

  factory Expiration.fromJson(String str) =>
      Expiration.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Expiration.fromMap(json) => Expiration(
        isAllowed: json["is_allowed"] ?? false,
        duration: json["duration"] ?? 0,
        method: json["method"] ?? 0,
        mode: json["mode"] ?? 0,
        isSessionExpiry: json["is_session_expiry"] ?? false,
      );

  Map<String, dynamic> toMap() => {
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

  factory Persistence.fromJson(String str) =>
      Persistence.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Persistence.fromMap(json) => Persistence(
        scope: json["scope"] ?? 0,
        isEncrypted: json["is_encrypted"] ?? false,
      );

  Map<String, dynamic> toMap() => {
        "scope": scope,
        "is_encrypted": isEncrypted,
      };
}
