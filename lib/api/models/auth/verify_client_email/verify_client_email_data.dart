class VerifyClientEmailData {
  VerifyClientEmailData({
      this.userId, 
      this.corporateName, 
      this.isCorporate,});

  VerifyClientEmailData.fromJson(dynamic json) {
    userId = json['user_id'];
    corporateName = json['corporate_name'];
    isCorporate = json['is_corporate'];
  }
  String? userId;
  String? corporateName;
  bool? isCorporate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = userId;
    map['corporate_name'] = corporateName;
    map['is_corporate'] = isCorporate;
    return map;
  }

}