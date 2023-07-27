/// scope : 0
/// is_encrypted : false

class Persistence {
  Persistence({
      this.scope, 
      this.isEncrypted,});

  Persistence.fromJson(dynamic json) {
    scope = json['scope'];
    isEncrypted = json['is_encrypted'];
  }
  int? scope;
  bool? isEncrypted;
Persistence copyWith({  int? scope,
  bool? isEncrypted,
}) => Persistence(  scope: scope ?? this.scope,
  isEncrypted: isEncrypted ?? this.isEncrypted,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['scope'] = scope;
    map['is_encrypted'] = isEncrypted;
    return map;
  }

}