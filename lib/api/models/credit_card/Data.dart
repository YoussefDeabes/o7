/// last_four_digits : "1234"
/// code : "CC-9207210530010112"
/// brand : 0
/// is_deleted : true
/// expiry_date : "20250501000000"
/// is_preferred : false

class CreditCardData {
  CreditCardData({
      this.lastFourDigits, 
      this.code, 
      this.brand, 
      this.isDeleted, 
      this.expiryDate, 
      this.isPreferred,});

  CreditCardData.fromJson(dynamic json) {
    lastFourDigits = json['last_four_digits'];
    code = json['code'];
    brand = json['brand'];
    isDeleted = json['is_deleted'];
    expiryDate = json['expiry_date'];
    isPreferred = json['is_preferred'];
  }
  String? lastFourDigits;
  String? code;
  int? brand;
  bool? isDeleted;
  String? expiryDate;
  bool? isPreferred;
  CreditCardData copyWith({  String? lastFourDigits,
  String? code,
  int? brand,
  bool? isDeleted,
  String? expiryDate,
  bool? isPreferred,
}) => CreditCardData(  lastFourDigits: lastFourDigits ?? this.lastFourDigits,
  code: code ?? this.code,
  brand: brand ?? this.brand,
  isDeleted: isDeleted ?? this.isDeleted,
  expiryDate: expiryDate ?? this.expiryDate,
  isPreferred: isPreferred ?? this.isPreferred,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['last_four_digits'] = lastFourDigits;
    map['code'] = code;
    map['brand'] = brand;
    map['is_deleted'] = isDeleted;
    map['expiry_date'] = expiryDate;
    map['is_preferred'] = isPreferred;
    return map;
  }

}