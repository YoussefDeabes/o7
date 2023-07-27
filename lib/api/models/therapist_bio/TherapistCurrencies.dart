import 'Currency.dart';

/// therapist_id : "string"
/// currency_id : 0
/// currency : {"id":0,"currency_code":"string","currency_name_ar":"string","currency_name_en":"string"}
/// value : 0

class TherapistCurrencies {
  TherapistCurrencies({
      this.therapistId, 
      this.currencyId, 
      this.currency, 
      this.value,});

  TherapistCurrencies.fromJson(dynamic json) {
    therapistId = json['therapist_id'];
    currencyId = json['currency_id'];
    currency = json['currency'] != null ? Currency.fromJson(json['currency']) : null;
    value = json['value'];
  }
  String? therapistId;
  int? currencyId;
  Currency? currency;
  int? value;
TherapistCurrencies copyWith({  String? therapistId,
  int? currencyId,
  Currency? currency,
  int? value,
}) => TherapistCurrencies(  therapistId: therapistId ?? this.therapistId,
  currencyId: currencyId ?? this.currencyId,
  currency: currency ?? this.currency,
  value: value ?? this.value,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['therapist_id'] = therapistId;
    map['currency_id'] = currencyId;
    if (currency != null) {
      map['currency'] = currency?.toJson();
    }
    map['value'] = value;
    return map;
  }

}