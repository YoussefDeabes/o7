class UpdateInsuranceCardParams {
  final int oldUserCardId;
  final String medicalCardNumber;
  final int insuranceCompanyId;
  UpdateInsuranceCardParams({
    required this.oldUserCardId,
    required this.medicalCardNumber,
    required this.insuranceCompanyId,
  });

  UpdateInsuranceCardParams copyWith({
    int? oldUserCardId,
    String? medicalCardNumber,
    int? insuranceCompanyId,
  }) {
    return UpdateInsuranceCardParams(
      oldUserCardId: oldUserCardId ?? this.oldUserCardId,
      medicalCardNumber: medicalCardNumber ?? this.medicalCardNumber,
      insuranceCompanyId: insuranceCompanyId ?? this.insuranceCompanyId,
    );
  }

  Map<String, dynamic> toDataMap() {
    return <String, dynamic>{
      "user_card_id": oldUserCardId,
      "medical_card_number": medicalCardNumber,
      "insurance_company_id": insuranceCompanyId,
    };
  }

  @override
  String toString() =>
      'UpdateInsuranceCardParams(oldUserCardId: $oldUserCardId, medicalCardNumber: $medicalCardNumber, insuranceCompanyId: $insuranceCompanyId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UpdateInsuranceCardParams &&
        other.oldUserCardId == oldUserCardId &&
        other.medicalCardNumber == medicalCardNumber &&
        other.insuranceCompanyId == insuranceCompanyId;
  }

  @override
  int get hashCode =>
      oldUserCardId.hashCode ^
      medicalCardNumber.hashCode ^
      insuranceCompanyId.hashCode;
}
