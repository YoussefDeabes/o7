/// original_fees_amount : 100.0
/// new_fees_amount : 100.0
/// discount_amount : 0.0
/// discount_percentage : 0.0
/// currency : "EGP"
/// insurance_id : null
/// insurance_name : null
/// is_out_side_range : false
/// flat_rate : false
/// flat_rate_max_fee : null

class Data {
  Data({
      this.originalFeesAmount, 
      this.newFeesAmount, 
      this.discountAmount, 
      this.discountPercentage, 
      this.currency, 
      this.insuranceId, 
      this.insuranceName, 
      this.isOutSideRange, 
      this.flatRate, 
      this.flatRateMaxFee,});

  Data.fromJson(dynamic json) {
    originalFeesAmount = json['original_fees_amount'];
    newFeesAmount = json['new_fees_amount'];
    discountAmount = json['discount_amount'];
    discountPercentage = json['discount_percentage'];
    currency = json['currency'];
    insuranceId = json['insurance_id'];
    insuranceName = json['insurance_name'];
    isOutSideRange = json['is_out_side_range'];
    flatRate = json['flat_rate'];
    flatRateMaxFee = json['flat_rate_max_fee'];
  }
  double? originalFeesAmount;
  double? newFeesAmount;
  double? discountAmount;
  double? discountPercentage;
  String? currency;
  dynamic insuranceId;
  dynamic insuranceName;
  bool? isOutSideRange;
  bool? flatRate;
  dynamic flatRateMaxFee;
Data copyWith({  double? originalFeesAmount,
  double? newFeesAmount,
  double? discountAmount,
  double? discountPercentage,
  String? currency,
  dynamic insuranceId,
  dynamic insuranceName,
  bool? isOutSideRange,
  bool? flatRate,
  dynamic flatRateMaxFee,
}) => Data(  originalFeesAmount: originalFeesAmount ?? this.originalFeesAmount,
  newFeesAmount: newFeesAmount ?? this.newFeesAmount,
  discountAmount: discountAmount ?? this.discountAmount,
  discountPercentage: discountPercentage ?? this.discountPercentage,
  currency: currency ?? this.currency,
  insuranceId: insuranceId ?? this.insuranceId,
  insuranceName: insuranceName ?? this.insuranceName,
  isOutSideRange: isOutSideRange ?? this.isOutSideRange,
  flatRate: flatRate ?? this.flatRate,
  flatRateMaxFee: flatRateMaxFee ?? this.flatRateMaxFee,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['original_fees_amount'] = originalFeesAmount;
    map['new_fees_amount'] = newFeesAmount;
    map['discount_amount'] = discountAmount;
    map['discount_percentage'] = discountPercentage;
    map['currency'] = currency;
    map['insurance_id'] = insuranceId;
    map['insurance_name'] = insuranceName;
    map['is_out_side_range'] = isOutSideRange;
    map['flat_rate'] = flatRate;
    map['flat_rate_max_fee'] = flatRateMaxFee;
    return map;
  }

}