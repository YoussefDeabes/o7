/// original_fees_amount : 100.0
/// new_fees_amount : 5.000
/// discount_amount : 95.000
/// discount_percentage : 95.00
/// currency : "EGP"

class PromoCodeData {
  PromoCodeData({
      this.originalFeesAmount, 
      this.newFeesAmount, 
      this.discountAmount, 
      this.discountPercentage, 
      this.currency,});

  PromoCodeData.fromJson(dynamic json) {
    originalFeesAmount = json['original_fees_amount'];
    newFeesAmount = json['new_fees_amount'];
    discountAmount = json['discount_amount'];
    discountPercentage = json['discount_percentage'];
    currency = json['currency'];
  }
  double? originalFeesAmount;
  double? newFeesAmount;
  double? discountAmount;
  double? discountPercentage;
  String? currency;
  PromoCodeData copyWith({  double? originalFeesAmount,
  double? newFeesAmount,
  double? discountAmount,
  double? discountPercentage,
  String? currency,
}) => PromoCodeData(  originalFeesAmount: originalFeesAmount ?? this.originalFeesAmount,
  newFeesAmount: newFeesAmount ?? this.newFeesAmount,
  discountAmount: discountAmount ?? this.discountAmount,
  discountPercentage: discountPercentage ?? this.discountPercentage,
  currency: currency ?? this.currency,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['original_fees_amount'] = originalFeesAmount;
    map['new_fees_amount'] = newFeesAmount;
    map['discount_amount'] = discountAmount;
    map['discount_percentage'] = discountPercentage;
    map['currency'] = currency;
    return map;
  }

}