class Data {
  Data({
      this.sessionId,});

  Data.fromJson(dynamic json) {
    sessionId = json['session_id'];
  }
  int? sessionId;
Data copyWith({  int? sessionId,
}) => Data(  sessionId: sessionId ?? this.sessionId,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['session_id'] = sessionId;
    return map;
  }

}