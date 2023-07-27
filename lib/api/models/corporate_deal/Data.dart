/// original_fees_amount : 100.0
/// new_fees_amount : 100.0
/// discount_amount : 0.0
/// discount_percentage : 0.0
/// currency : "EGP"
/// corporate_id : null
/// corporate_name : null
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
      this.corporateId, 
      this.corporateName, 
      this.isOutSideRange, 
      this.flatRate, 
      this.flatRateMaxFee,});

  Data.fromJson(dynamic json) {
    originalFeesAmount = json['original_fees_amount'];
    newFeesAmount = json['new_fees_amount'];
    discountAmount = json['discount_amount'];
    discountPercentage = json['discount_percentage'];
    currency = json['currency'];
    corporateId = json['corporate_id'];
    corporateName = json['corporate_name'];
    isOutSideRange = json['is_out_side_range'];
    flatRate = json['flat_rate'];
    flatRateMaxFee = json['flat_rate_max_fee'];
  }
  double? originalFeesAmount;
  double? newFeesAmount;
  double? discountAmount;
  double? discountPercentage;
  String? currency;
  dynamic corporateId;
  dynamic corporateName;
  bool? isOutSideRange;
  bool? flatRate;
  dynamic flatRateMaxFee;
Data copyWith({  double? originalFeesAmount,
  double? newFeesAmount,
  double? discountAmount,
  double? discountPercentage,
  String? currency,
  dynamic corporateId,
  dynamic corporateName,
  bool? isOutSideRange,
  bool? flatRate,
  dynamic flatRateMaxFee,
}) => Data(  originalFeesAmount: originalFeesAmount ?? this.originalFeesAmount,
  newFeesAmount: newFeesAmount ?? this.newFeesAmount,
  discountAmount: discountAmount ?? this.discountAmount,
  discountPercentage: discountPercentage ?? this.discountPercentage,
  currency: currency ?? this.currency,
  corporateId: corporateId ?? this.corporateId,
  corporateName: corporateName ?? this.corporateName,
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
    map['corporate_id'] = corporateId;
    map['corporate_name'] = corporateName;
    map['is_out_side_range'] = isOutSideRange;
    map['flat_rate'] = flatRate;
    map['flat_rate_max_fee'] = flatRateMaxFee;
    return map;
  }

}