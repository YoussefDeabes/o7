class Claims {
  Claims({
    this.additionalProp1,
    this.additionalProp2,
    this.additionalProp3,
  });

  Claims.fromJson(dynamic json) {
    additionalProp1 = json['additionalProp1'];
    additionalProp2 = json['additionalProp2'];
    additionalProp3 = json['additionalProp3'];
  }
  String? additionalProp1;
  String? additionalProp2;
  String? additionalProp3;
  Claims copyWith({
    String? additionalProp1,
    String? additionalProp2,
    String? additionalProp3,
  }) =>
      Claims(
        additionalProp1: additionalProp1 ?? this.additionalProp1,
        additionalProp2: additionalProp2 ?? this.additionalProp2,
        additionalProp3: additionalProp3 ?? this.additionalProp3,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['additionalProp1'] = additionalProp1;
    map['additionalProp2'] = additionalProp2;
    map['additionalProp3'] = additionalProp3;
    return map;
  }
}
