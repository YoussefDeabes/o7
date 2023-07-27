import "package:o7therapy/api/models/auth/sign_up_models/sign_up_models.dart";

// adel2@yahoo.com
// example for returned data >>  7c6018f3-63fc-4c53-bfbd-084b5bd0a34d
class SignUpWrapper {
  SignUpWrapper({
    required this.userId,
    required this.errorCode,
    required this.errorMsg,
    required this.errorDetails,
    required this.expiration,
    required this.persistence,
    required this.totalSeconds,
  });

  /// returned data is user_id >>  7c6018f3-63fc-4c53-bfbd-084b5bd0a34d
  final String? userId;

  final int? errorCode;
  final String? errorMsg;
  final String? errorDetails;
  final Expiration? expiration;
  final Persistence? persistence;
  final int? totalSeconds;

  factory SignUpWrapper.fromJson(json) => SignUpWrapper(
        userId: json["data"],
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
        "data": userId,
        "error_code": errorCode,
        "error_msg": errorMsg,
        "error_details": errorDetails,
        "expiration": expiration?.toJson(),
        "persistence": persistence?.toJson(),
        "total_seconds": totalSeconds,
      };
}
