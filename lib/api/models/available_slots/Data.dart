class Data {
  Data({
      this.id, 
      this.from, 
      this.to,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    from = json['from'];
    to = json['to'];
  }
  int? id;
  String? from;
  String? to;
Data copyWith({  int? id,
  String? from,
  String? to,
}) => Data(  id: id ?? this.id,
  from: from ?? this.from,
  to: to ?? this.to,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['from'] = from;
    map['to'] = to;
    return map;
  }

}