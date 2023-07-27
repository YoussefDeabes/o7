class NotificationsMarkAllAsReadWrapper {
  NotificationsMarkAllAsReadWrapper({
    required this.errorCode,
    required this.errorMsg,
    required this.errorDetails,
    required this.totalSeconds,
  });

  final int errorCode;
  final String errorMsg;
  final String errorDetails;
  final int totalSeconds;

  factory NotificationsMarkAllAsReadWrapper.fromJson(json) =>
      NotificationsMarkAllAsReadWrapper(
        errorCode: json["error_code"],
        errorMsg: json["error_msg"],
        errorDetails: json["error_details"],
        totalSeconds: json["total_seconds"],
      );

  Map<String, dynamic> toJson() => {
        "error_code": errorCode,
        "error_msg": errorMsg,
        "error_details": errorDetails,
        "total_seconds": totalSeconds,
      };
}
