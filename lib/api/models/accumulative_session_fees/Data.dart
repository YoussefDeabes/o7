class Data {
  Data({
      this.egpAmount, 
      this.usdAmount, 
      this.currency,});

  Data.fromJson(dynamic json) {
    egpAmount = json['egp_amount'];
    usdAmount = json['usd_amount'];
    currency = json['currency'];
  }
  double? egpAmount;
  double? usdAmount;
  String? currency;
Data copyWith({  double? egpAmount,
  double? usdAmount,
  String? currency,
}) => Data(  egpAmount: egpAmount ?? this.egpAmount,
  usdAmount: usdAmount ?? this.usdAmount,
  currency: currency ?? this.currency,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['egp_amount'] = egpAmount;
    map['usd_amount'] = usdAmount;
    map['currency'] = currency;
    return map;
  }

}