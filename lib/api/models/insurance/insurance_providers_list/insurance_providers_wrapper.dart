import 'package:o7therapy/api/models/insurance/insurance_providers_list/insurance_providers_list.dart';

class InsuranceProvidersWrapper {
  InsuranceProvidersWrapper({
    required this.data,
    required this.errorCode,
    required this.errorMsg,
    required this.errorDetails,
    required this.expiration,
    required this.persistence,
    required this.totalSeconds,
  });

  final List<ProviderData> data;
  final int errorCode;
  final String errorMsg;
  final String errorDetails;
  final Expiration expiration;
  final Persistence persistence;
  final int totalSeconds;

  factory InsuranceProvidersWrapper.fromJson(json) => InsuranceProvidersWrapper(
        data: List<ProviderData>.from(
            json["data"].map((x) => ProviderData.fromJson(x))),
        errorCode: json["error_code"],
        errorMsg: json["error_msg"],
        errorDetails: json["error_details"],
        expiration: Expiration.fromJson(json["expiration"]),
        persistence: Persistence.fromJson(json["persistence"]),
        totalSeconds: json["total_seconds"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "error_code": errorCode,
        "error_msg": errorMsg,
        "error_details": errorDetails,
        "expiration": expiration.toJson(),
        "persistence": persistence.toJson(),
        "total_seconds": totalSeconds,
      };

  InsuranceProvidersWrapper copyWith({
    List<ProviderData>? data,
    int? errorCode,
    String? errorMsg,
    String? errorDetails,
    Expiration? expiration,
    Persistence? persistence,
    int? totalSeconds,
  }) =>
      InsuranceProvidersWrapper(
        data: data ?? this.data,
        errorCode: errorCode ?? this.errorCode,
        errorMsg: errorMsg ?? this.errorMsg,
        errorDetails: errorDetails ?? this.errorDetails,
        expiration: expiration ?? this.expiration,
        persistence: persistence ?? this.persistence,
        totalSeconds: totalSeconds ?? this.totalSeconds,
      );
}
