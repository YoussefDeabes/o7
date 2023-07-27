/// fees_amount : 0.0
/// fees_percentage : 0.0
/// currency : "EGP"
/// flat_rate : false

class Data {
  Data({
      this.feesAmount, 
      this.feesPercentage, 
      this.currency, 
      this.flatRate,});

  Data.fromJson(dynamic json) {
    feesAmount = json['fees_amount'];
    feesPercentage = json['fees_percentage'];
    currency = json['currency'];
    flatRate = json['flat_rate'];
  }
  double? feesAmount;
  double? feesPercentage;
  String? currency;
  bool? flatRate;
Data copyWith({  double? feesAmount,
  double? feesPercentage,
  String? currency,
  bool? flatRate,
}) => Data(  feesAmount: feesAmount ?? this.feesAmount,
  feesPercentage: feesPercentage ?? this.feesPercentage,
  currency: currency ?? this.currency,
  flatRate: flatRate ?? this.flatRate,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['fees_amount'] = feesAmount;
    map['fees_percentage'] = feesPercentage;
    map['currency'] = currency;
    map['flat_rate'] = flatRate;
    return map;
  }

}