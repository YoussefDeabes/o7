/// id : 19
/// duration : 50.00

class PatientWallet {
  PatientWallet({
      this.id, 
      this.duration,});

  PatientWallet.fromJson(dynamic json) {
    id = json['id'];
    duration = json['duration'];
  }
  int? id;
  double? duration;
PatientWallet copyWith({  int? id,
  double? duration,
}) => PatientWallet(  id: id ?? this.id,
  duration: duration ?? this.duration,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['duration'] = duration;
    return map;
  }

}