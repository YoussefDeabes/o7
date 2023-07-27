class Persistence {
  Persistence({
    required this.scope,
    required this.isEncrypted,
  });

  final int? scope;
  final bool? isEncrypted;

  factory Persistence.fromJson(json) => Persistence(
        scope: json["scope"],
        isEncrypted: json["is_encrypted"],
      );

  Map<String, dynamic> toJson() => {
        "scope": scope,
        "is_encrypted": isEncrypted,
      };
}
