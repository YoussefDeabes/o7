class CheckVerifiedEmailData {
  CheckVerifiedEmailData({
      this.isVerified,
      this.dob,
      this.clientGoals,
      this.gender,});

  CheckVerifiedEmailData.fromJson(dynamic json) {
    isVerified = json['is_verified'];
    dob = json['dob'];
    clientGoals = json['client_goals'] != null ? json['client_goals'].cast<String>() : [];
    gender = json['gender'];
  }
  bool? isVerified;
  String? dob;
  List<String?>? clientGoals;
  int? gender;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['is_verified'] = isVerified;
    map['dob'] = dob;
    map['client_goals'] = clientGoals;
    map['gender'] = gender;
    return map;
  }

}