class Expiration {
  Expiration({
    required this.isAllowed,
    required this.duration,
    required this.method,
    required this.mode,
    required this.isSessionExpiry,
  });

  final bool isAllowed;
  final int duration;
  final int method;
  final int mode;
  final bool isSessionExpiry;

  Expiration copyWith({
    bool? isAllowed,
    int? duration,
    int? method,
    int? mode,
    bool? isSessionExpiry,
  }) =>
      Expiration(
        isAllowed: isAllowed ?? this.isAllowed,
        duration: duration ?? this.duration,
        method: method ?? this.method,
        mode: mode ?? this.mode,
        isSessionExpiry: isSessionExpiry ?? this.isSessionExpiry,
      );

  factory Expiration.fromJson(json) => Expiration(
        isAllowed: json["is_allowed"],
        duration: json["duration"],
        method: json["method"],
        mode: json["mode"],
        isSessionExpiry: json["is_session_expiry"],
      );

  Map<String, dynamic> toJson() => {
        "is_allowed": isAllowed,
        "duration": duration,
        "method": method,
        "mode": mode,
        "is_session_expiry": isSessionExpiry,
      };
}
