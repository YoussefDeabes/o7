/// currency : "EGP"
/// subscription_fees : 0.0
/// patient_id : null
/// discount_source : 1
/// discount_amount : 280.00
/// discount_precentage : 0.0
/// id : 0.0
/// name : ""
/// subscription_id : 2

class Data {
  Data({
      this.currency, 
      this.subscriptionFees, 
      this.patientId, 
      this.discountSource, 
      this.discountAmount, 
      this.discountPrecentage, 
      this.id, 
      this.name, 
      this.subscriptionId,
      this.corpSubscribedRassel
      });

  Data.fromJson(dynamic json) {
    currency = json['currency'];
    subscriptionFees = json['subscription_fees'];
    patientId = json['patient_id'];
    discountSource = json['discount_source'];
    discountAmount = json['discount_amount'];
    discountPrecentage = json['discount_precentage'];
    id = json['id'];
    name = json['name'];
    subscriptionId = json['subscription_id'];
    corpSubscribedRassel = json['corp_subscribed_rassel'];
  }
  String? currency;
  num? subscriptionFees;
  dynamic patientId;
  num? discountSource;
  num? discountAmount;
  num? discountPrecentage;
  num? id;
  String? name;
  num? subscriptionId;
  bool? corpSubscribedRassel;
Data copyWith({  String? currency,
  num? subscriptionFees,
  dynamic patientId,
  num? discountSource,
  num? discountAmount,
  num? discountPrecentage,
  num? id,
  String? name,
  num? subscriptionId,
  bool? corpSubscribedRassel,
}) => Data(  currency: currency ?? this.currency,
  subscriptionFees: subscriptionFees ?? this.subscriptionFees,
  patientId: patientId ?? this.patientId,
  discountSource: discountSource ?? this.discountSource,
  discountAmount: discountAmount ?? this.discountAmount,
  discountPrecentage: discountPrecentage ?? this.discountPrecentage,
  id: id ?? this.id,
  name: name ?? this.name,
  subscriptionId: subscriptionId ?? this.subscriptionId,
  corpSubscribedRassel: corpSubscribedRassel ?? this.corpSubscribedRassel,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['currency'] = currency;
    map['subscription_fees'] = subscriptionFees;
    map['patient_id'] = patientId;
    map['discount_source'] = discountSource;
    map['discount_amount'] = discountAmount;
    map['discount_precentage'] = discountPrecentage;
    map['id'] = id;
    map['name'] = name;
    map['subscription_id'] = subscriptionId;
    map['corp_subscribed_rassel'] = corpSubscribedRassel;
    return map;
  }

}