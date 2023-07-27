class Persistence {
  Persistence({
    required this.scope,
    required this.isEncrypted,
  });

  final int scope;
  final bool isEncrypted;

  Persistence copyWith({
    int? scope,
    bool? isEncrypted,
  }) =>
      Persistence(
        scope: scope ?? this.scope,
        isEncrypted: isEncrypted ?? this.isEncrypted,
      );

  factory Persistence.fromJson(json) => Persistence(
        scope: json["scope"],
        isEncrypted: json["is_encrypted"],
      );

  Map<String, dynamic> toJson() => {
        "scope": scope,
        "is_encrypted": isEncrypted,
      };
}
