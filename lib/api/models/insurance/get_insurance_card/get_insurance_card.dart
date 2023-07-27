class GetInsuranceCardWrapper {
  GetInsuranceCardWrapper({
    required this.data,
    required this.errorCode,
    required this.errorMsg,
    required this.errorDetails,
    required this.expiration,
    required this.persistence,
    required this.totalSeconds,
  });

  final List<InsuranceCard> data;
  final int errorCode;
  final String errorMsg;
  final String errorDetails;
  final Expiration expiration;
  final Persistence persistence;
  final int totalSeconds;

  factory GetInsuranceCardWrapper.fromJson(Map<String, dynamic> json) =>
      GetInsuranceCardWrapper(
        data: List<InsuranceCard>.from(
            json["data"].map((x) => InsuranceCard.fromJson(x))),
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
}

class InsuranceCard {
  InsuranceCard({
    required this.cardId,
    required this.medicalCardNumber,
    required this.insuranceProvider,
    required this.dateOfBirth,
    required this.cardVerified,
  });

  final int cardId;
  final String medicalCardNumber;
  final String insuranceProvider;
  final DateTime dateOfBirth;
  final bool cardVerified;

  factory InsuranceCard.fromJson(Map<String, dynamic> json) => InsuranceCard(
        cardId: json["card_id"],
        medicalCardNumber: json["medical_card_number"],
        insuranceProvider: json["insurance_provider"],
        dateOfBirth: DateTime.parse(json["date_of_birth"]),
        cardVerified: json["card_verified"],
      );

  Map<String, dynamic> toJson() => {
        "card_id": cardId,
        "medical_card_number": medicalCardNumber,
        "insurance_provider": insuranceProvider,
        "date_of_birth": dateOfBirth.toIso8601String(),
        "card_verified": cardVerified,
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

  final int scope;
  final bool isEncrypted;

  factory Persistence.fromJson(Map<String, dynamic> json) => Persistence(
        scope: json["scope"],
        isEncrypted: json["is_encrypted"],
      );

  Map<String, dynamic> toJson() => {
        "scope": scope,
        "is_encrypted": isEncrypted,
      };
}
