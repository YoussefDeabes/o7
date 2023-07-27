class RefreshTokenWrapper {
  RefreshTokenWrapper({
    required this.data,
    required this.errorCode,
    required this.errorMsg,
    required this.errorDetails,
    required this.totalSeconds,
  });

  final Data? data;
  final int? errorCode;
  final String? errorMsg;
  final String? errorDetails;
  final int? totalSeconds;

  factory RefreshTokenWrapper.fromJson(Map<String, dynamic> json) =>
      RefreshTokenWrapper(
        data: Data.fromJson(json["data"]),
        errorCode: json["error_code"],
        errorMsg: json["error_msg"],
        errorDetails: json["error_details"],
        totalSeconds: json["total_seconds"],
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "error_code": errorCode,
        "error_msg": errorMsg,
        "error_details": errorDetails,
        "total_seconds": totalSeconds,
      };
}

class Data {
  Data({
    required this.accessToken,
    required this.tokenType,
    required this.expiresInSeconds,
    required this.refreshToken,
    required this.accessTokenType,
  });

  final String? accessToken;
  final String? tokenType;
  final int? expiresInSeconds;
  final String? refreshToken;
  final String? accessTokenType;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        expiresInSeconds: json["expires_in_seconds"],
        refreshToken: json["refresh_token"],
        accessTokenType: json["access_token_type"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "expires_in_seconds": expiresInSeconds,
        "refresh_token": refreshToken,
        "access_token_type": accessTokenType,
      };
}
