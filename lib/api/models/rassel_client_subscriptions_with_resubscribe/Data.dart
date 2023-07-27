/// id : 50
/// client_id : "c2d1f815-e39a-4f42-89cd-9eaa9f3370c6"
/// subscription_id : 2
/// subscroption_name : "Rasel Subscription"
/// status : 3
/// is_active : false
/// corporate_id : 2
/// is_poromotion : true
/// paid_fees : 175.00
/// corporate_name : "dd"
/// next_payment_amount : 350.00
/// next_payment_date : "2024-01-10T09:13:09.8270964"
/// currency : "EGP"

class Data {
  Data({
      this.id, 
      this.clientId, 
      this.subscriptionId, 
      this.subscroptionName, 
      this.status, 
      this.isActive, 
      this.corporateId, 
      this.isPoromotion, 
      this.paidFees, 
      this.corporateName, 
      this.nextPaymentAmount, 
      this.nextPaymentDate, 
      this.currency,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    clientId = json['client_id'];
    subscriptionId = json['subscription_id'];
    subscroptionName = json['subscroption_name'];
    status = json['status'];
    isActive = json['is_active'];
    corporateId = json['corporate_id'];
    isPoromotion = json['is_poromotion'];
    paidFees = json['paid_fees'];
    corporateName = json['corporate_name'];
    nextPaymentAmount = json['next_payment_amount'];
    nextPaymentDate = json['next_payment_date'];
    currency = json['currency'];
  }
  num? id;
  String? clientId;
  num? subscriptionId;
  String? subscroptionName;
  num? status;
  bool? isActive;
  num? corporateId;
  bool? isPoromotion;
  num? paidFees;
  String? corporateName;
  num? nextPaymentAmount;
  String? nextPaymentDate;
  String? currency;
Data copyWith({  num? id,
  String? clientId,
  num? subscriptionId,
  String? subscroptionName,
  num? status,
  bool? isActive,
  num? corporateId,
  bool? isPoromotion,
  num? paidFees,
  String? corporateName,
  num? nextPaymentAmount,
  String? nextPaymentDate,
  String? currency,
}) => Data(  id: id ?? this.id,
  clientId: clientId ?? this.clientId,
  subscriptionId: subscriptionId ?? this.subscriptionId,
  subscroptionName: subscroptionName ?? this.subscroptionName,
  status: status ?? this.status,
  isActive: isActive ?? this.isActive,
  corporateId: corporateId ?? this.corporateId,
  isPoromotion: isPoromotion ?? this.isPoromotion,
  paidFees: paidFees ?? this.paidFees,
  corporateName: corporateName ?? this.corporateName,
  nextPaymentAmount: nextPaymentAmount ?? this.nextPaymentAmount,
  nextPaymentDate: nextPaymentDate ?? this.nextPaymentDate,
  currency: currency ?? this.currency,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['client_id'] = clientId;
    map['subscription_id'] = subscriptionId;
    map['subscroption_name'] = subscroptionName;
    map['status'] = status;
    map['is_active'] = isActive;
    map['corporate_id'] = corporateId;
    map['is_poromotion'] = isPoromotion;
    map['paid_fees'] = paidFees;
    map['corporate_name'] = corporateName;
    map['next_payment_amount'] = nextPaymentAmount;
    map['next_payment_date'] = nextPaymentDate;
    map['currency'] = currency;
    return map;
  }

}