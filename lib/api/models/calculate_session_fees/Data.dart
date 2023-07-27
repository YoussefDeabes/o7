/// refund_amount : 50.00
/// flat_rate : false
/// fees_amount : 0.00
/// fees_percentage : 0.0
/// currency : "EGP"

class Data {
  Data({
    this.refundAmount,
    this.flatRate,
    this.corporateId,
    this.insuranceId,
    this.feesAmount,
    this.feesPercentage,
    this.currency,
  });

  Data.fromJson(dynamic json) {
    refundAmount = json['refund_amount'];
    flatRate = json['flat_rate'];
    corporateId = json['corporate_id'];
    insuranceId = json['insurance_id'];
    feesAmount = json['fees_amount'];
    feesPercentage = json['fees_percentage'];
    currency = json['currency'];
  }
  double? refundAmount;
  bool? flatRate;
  double? feesAmount;
  double? feesPercentage;
  String? currency;
  int? corporateId;
  int? insuranceId;
  Data copyWith({
    double? refundAmount,
    bool? flatRate,
    double? feesAmount,
    double? feesPercentage,
    String? currency,
    int? corporateId,
    int? insuranceId,
  }) =>
      Data(
        refundAmount: refundAmount ?? this.refundAmount,
        flatRate: flatRate ?? this.flatRate,
        feesAmount: feesAmount ?? this.feesAmount,
        feesPercentage: feesPercentage ?? this.feesPercentage,
        currency: currency ?? this.currency,
        corporateId: corporateId ?? this.corporateId,
        insuranceId: insuranceId ?? this.insuranceId,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['refund_amount'] = refundAmount;
    map['flat_rate'] = flatRate;
    map['fees_amount'] = feesAmount;
    map['fees_percentage'] = feesPercentage;
    map['currency'] = currency;
    map['insurance_id'] = insuranceId;
    map['corporate_id'] = corporateId;
    return map;
  }
}
