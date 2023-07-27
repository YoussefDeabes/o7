/// id : 0
/// currency_code : "string"
/// currency_name_ar : "string"
/// currency_name_en : "string"

class Currency {
  Currency({
      this.id, 
      this.currencyCode, 
      this.currencyNameAr, 
      this.currencyNameEn,});

  Currency.fromJson(dynamic json) {
    id = json['id'];
    currencyCode = json['currency_code'];
    currencyNameAr = json['currency_name_ar'];
    currencyNameEn = json['currency_name_en'];
  }
  int? id;
  String? currencyCode;
  String? currencyNameAr;
  String? currencyNameEn;
Currency copyWith({  int? id,
  String? currencyCode,
  String? currencyNameAr,
  String? currencyNameEn,
}) => Currency(  id: id ?? this.id,
  currencyCode: currencyCode ?? this.currencyCode,
  currencyNameAr: currencyNameAr ?? this.currencyNameAr,
  currencyNameEn: currencyNameEn ?? this.currencyNameEn,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['currency_code'] = currencyCode;
    map['currency_name_ar'] = currencyNameAr;
    map['currency_name_en'] = currencyNameEn;
    return map;
  }

}