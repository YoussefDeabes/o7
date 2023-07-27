class Expiration {
  Expiration({
    this.isAllowed,
    this.duration,
    this.method,
    this.mode,
    this.isSessionExpiry,
  });

  Expiration.fromJson(dynamic json) {
    isAllowed = json['is_allowed'];
    duration = json['duration'];
    method = json['method'];
    mode = json['mode'];
    isSessionExpiry = json['is_session_expiry'];
  }
  bool? isAllowed;
  int? duration;
  int? method;
  int? mode;
  bool? isSessionExpiry;
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
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['is_allowed'] = isAllowed;
    map['duration'] = duration;
    map['method'] = method;
    map['mode'] = mode;
    map['is_session_expiry'] = isSessionExpiry;
    return map;
  }
}
