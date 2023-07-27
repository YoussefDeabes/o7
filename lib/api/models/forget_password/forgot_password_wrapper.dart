class ForgotPasswordWrapper {
  ForgotPasswordWrapper({
    required this.errorCode,
    required this.userReferenceNumber,
    required this.errorMsg,
    required this.errorDetails,
    required this.totalSeconds,
  });

  final int? errorCode;
  final String? userReferenceNumber;
  final String? errorMsg;
  final String? errorDetails;
  final int? totalSeconds;

  factory ForgotPasswordWrapper.fromJson(json) => ForgotPasswordWrapper(
        errorCode: json["error_code"],
        userReferenceNumber: json["data"],
        errorMsg: json["error_msg"],
        errorDetails: json["error_details"],
        totalSeconds: json["total_seconds"],
      );
}
