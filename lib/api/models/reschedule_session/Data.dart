/// require_payment : false

class Data {
  Data({
      this.requirePayment,});

  Data.fromJson(dynamic json) {
    requirePayment = json['require_payment'];
  }
  bool? requirePayment;
Data copyWith({  bool? requirePayment,
}) => Data(  requirePayment: requirePayment ?? this.requirePayment,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['require_payment'] = requirePayment;
    return map;
  }

}