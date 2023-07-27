class PhoneMaskedNumberModel {
  PhoneMaskedNumberModel({
    required this.data,
    required this.errorCode,
    required this.errorMsg,
    required this.errorDetails,
    required this.totalSeconds,
  });

  final String data;
  final int errorCode;
  final String errorMsg;
  final String errorDetails;
  final int totalSeconds;

  factory PhoneMaskedNumberModel.fromJson(Map<String, dynamic> json) =>
      PhoneMaskedNumberModel(
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
