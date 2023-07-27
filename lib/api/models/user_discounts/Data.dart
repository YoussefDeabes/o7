class Data {
  Data({
      this.isCorporate, 
      this.isInsurance, 
      this.isFlatRate, 
      this.hasSessionsOnWallet, 
      this.inDebt,
      this.companyCode,
      this.corporateName,
      this.userReferenceNumber,
      this.discount,
  });

  Data.fromJson(dynamic json) {
    isCorporate = json['is_corporate'];
    isInsurance = json['is_insurance'];
    isFlatRate = json['is_flat_rate'];
    hasSessionsOnWallet = json['has_sessions_on_wallet'];
    inDebt = json['in_debt'];
    companyCode = json['company_code'];
    userReferenceNumber = json['user_ref_number'];
    corporateName = json['corporate_name'];
    discount = json['discount'];
  }
  bool? isCorporate;
  bool? isInsurance;
  bool? isFlatRate;
  bool? hasSessionsOnWallet;
  bool? inDebt;
  String? companyCode;
  String? userReferenceNumber;
  String? corporateName;
  double? discount;
Data copyWith({  bool? isCorporate,
  bool? isInsurance,
  bool? isFlatRate,
  bool? hasSessionsOnWallet,
  bool? inDebt,
  String? companyCode,
  String? corporateName,
  String? userReferenceNumber,
  double? discount,
}) => Data(  isCorporate: isCorporate ?? this.isCorporate,
  isInsurance: isInsurance ?? this.isInsurance,
  isFlatRate: isFlatRate ?? this.isFlatRate,
  hasSessionsOnWallet: hasSessionsOnWallet ?? this.hasSessionsOnWallet,
  inDebt: inDebt ?? this.inDebt,
  companyCode: companyCode ?? this.companyCode,
  corporateName: corporateName ?? this.corporateName,
  userReferenceNumber: userReferenceNumber ?? this.userReferenceNumber,
  discount: discount ?? this.discount,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['is_corporate'] = isCorporate;
    map['is_insurance'] = isInsurance;
    map['is_flat_rate'] = isFlatRate;
    map['has_sessions_on_wallet'] = hasSessionsOnWallet;
    map['in_debt'] = inDebt;
    map['company_code'] = companyCode;
    map['user_ref_number'] = userReferenceNumber;
    map['corporate_name'] = corporateName;
    map['discount'] = discount;
    return map;
  }
}
