/// id : 3
/// client_id : "c2d1f815-e39a-4f42-89cd-9eaa9f3370c6"
/// subscription_id : 2
/// subscroption_name : "Rasel Subscription"
/// status : 1
/// is_active : true
/// corporate_id : null
/// is_poromotion : true
/// paid_fees : 175.00
/// corporate_name : null

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
    this.nextPayAmount,
    this.nextPayDate,
    this.currency

  });

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
    nextPayAmount = json['next_payment_amount'];
    nextPayDate = json['next_payment_date'];
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
  num? nextPayAmount;
  String? nextPayDate ;
  String? currency ;

  Data copyWith({
    num? id,
    String? clientId,
    num? subscriptionId,
    String? subscroptionName,
    num? status,
    bool? isActive,
    num? corporateId,
    bool? isPoromotion,
    num? paidFees,
    String? corporateName,
    num? nextPayAmount,
    String? nextPayDate,
    String? currency,
  }) =>
      Data(
        id: id ?? this.id,
        clientId: clientId ?? this.clientId,
        subscriptionId: subscriptionId ?? this.subscriptionId,
        subscroptionName: subscroptionName ?? this.subscroptionName,
        status: status ?? this.status,
        isActive: isActive ?? this.isActive,
        corporateId: corporateId ?? this.corporateId,
        isPoromotion: isPoromotion ?? this.isPoromotion,
        paidFees: paidFees ?? this.paidFees,
        corporateName: corporateName ?? this.corporateName,
          nextPayAmount:nextPayAmount??this.nextPayAmount,
          nextPayDate:nextPayDate??this.nextPayDate,
        currency:currency??this.currency,
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
    map['next_payment_amount'] =nextPayAmount;
    map['next_payment_date'] =nextPayDate;
    map['currency'] =currency;
    return map;
  }
}
