class Data {
  Data({
    this.meetingId,
    this.meetingPassword,
    this.maxEndDate,
    this.assumedStartDate,
    this.startedDate,
    this.participantMeetingUrl,
    this.isZoom,
    this.enforceSwitch,
  });

  Data.fromJson(dynamic json) {
    meetingId = json['meeting_id'];
    meetingPassword = json['meeting_password'];
    maxEndDate = json['max_end_date'];
    assumedStartDate = json['assumed_start_date'];
    startedDate = json['started_date'];
    participantMeetingUrl = json['participant_meeting_url'];
    isZoom = json['is_zoom'];
    enforceSwitch = json['enforce_switch'];
  }
  String? meetingId;
  String? meetingPassword;
  dynamic maxEndDate;
  dynamic assumedStartDate;
  dynamic startedDate;
  String? participantMeetingUrl;
  bool? isZoom;
  bool? enforceSwitch;
  Data copyWith({
    String? meetingId,
    String? meetingPassword,
    dynamic maxEndDate,
    dynamic assumedStartDate,
    dynamic startedDate,
    String? participantMeetingUrl,
    bool? isZoom,
    bool? enforceSwitch,
  }) =>
      Data(
        meetingId: meetingId ?? this.meetingId,
        meetingPassword: meetingPassword ?? this.meetingPassword,
        maxEndDate: maxEndDate ?? this.maxEndDate,
        assumedStartDate: assumedStartDate ?? this.assumedStartDate,
        startedDate: startedDate ?? this.startedDate,
        participantMeetingUrl:
            participantMeetingUrl ?? this.participantMeetingUrl,
        isZoom: isZoom ?? this.isZoom,
        enforceSwitch: isZoom ?? this.enforceSwitch,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['meeting_id'] = meetingId;
    map['meeting_password'] = meetingPassword;
    map['max_end_date'] = maxEndDate;
    map['assumed_start_date'] = assumedStartDate;
    map['started_date'] = startedDate;
    map['participant_meeting_url'] = participantMeetingUrl;
    map['is_zoom'] = isZoom;
    map['enforce_switch'] = enforceSwitch;
    return map;
  }
}
