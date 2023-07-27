import 'TherapistImage.dart';

class PastListData {
  PastListData({
    this.therapistId,
    this.therapistName,
    this.therapistProfession,
    this.therapistImage,
    this.currency,
    this.fees,
    this.id,
    this.dateFrom,
    this.startedDate,
    this.endedDate,
    this.status,
    this.canceledBySystemReason,
    this.therapistJoinedDate,
    this.patientJoinedDate,
    this.sessionStatusConfirmedByClient,
  });

  PastListData.fromJson(dynamic json) {
    therapistId = json['therapist_id'];
    therapistName = json['therapist_name'];
    therapistProfession = json['therapist_profession'];
    therapistImage = json['therapist_image'] != null
        ? TherapistImage.fromJson(json['therapist_image'])
        : null;
    currency = json['currency'];
    fees = json['fees'];
    id = json['id'];
    dateFrom = json['date_from'];
    startedDate = json['started_date'];
    endedDate = json['ended_date'];
    status = json['status'];
    canceledBySystemReason = json['canceled_by_system_reason'];
    therapistJoinedDate = json['therapist_joined_date'];
    patientJoinedDate = json['patient_joined_date'];
    sessionStatusConfirmedByClient = json['session_status_confirmed_by_client'];
  }
  String? therapistId;
  String? therapistName;
  String? therapistProfession;
  TherapistImage? therapistImage;
  String? currency;
  double? fees;
  int? id;
  String? dateFrom;
  String? startedDate;
  String? endedDate;
  int? status;
  int? canceledBySystemReason;
  String? therapistJoinedDate;
  String? patientJoinedDate;
  bool? sessionStatusConfirmedByClient;
  PastListData copyWith({
    String? therapistId,
    String? therapistName,
    String? therapistProfession,
    TherapistImage? therapistImage,
    String? currency,
    double? fees,
    int? id,
    String? dateFrom,
    String? startedDate,
    String? endedDate,
    int? status,
    int? canceledBySystemReason,
    String? therapistJoinedDate,
    String? patientJoinedDate,
    bool? sessionStatusConfirmedByClient,
  }) =>
      PastListData(
        therapistId: therapistId ?? this.therapistId,
        therapistName: therapistName ?? this.therapistName,
        therapistProfession: therapistProfession ?? this.therapistProfession,
        therapistImage: therapistImage ?? this.therapistImage,
        currency: currency ?? this.currency,
        fees: fees ?? this.fees,
        id: id ?? this.id,
        dateFrom: dateFrom ?? this.dateFrom,
        startedDate: startedDate ?? this.startedDate,
        endedDate: endedDate ?? this.endedDate,
        status: status ?? this.status,
        canceledBySystemReason:
            canceledBySystemReason ?? this.canceledBySystemReason,
        therapistJoinedDate: therapistJoinedDate ?? this.therapistJoinedDate,
        patientJoinedDate: patientJoinedDate ?? this.patientJoinedDate,
        sessionStatusConfirmedByClient: sessionStatusConfirmedByClient ??
            this.sessionStatusConfirmedByClient,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['therapist_id'] = therapistId;
    map['therapist_name'] = therapistName;
    map['therapist_profession'] = therapistProfession;
    if (therapistImage != null) {
      map['therapist_image'] = therapistImage?.toJson();
    }
    map['currency'] = currency;
    map['fees'] = fees;
    map['id'] = id;
    map['date_from'] = dateFrom;
    map['started_date'] = startedDate;
    map['ended_date'] = endedDate;
    map['status'] = status;
    map['canceled_by_system_reason'] = canceledBySystemReason;
    map['therapist_joined_date'] = therapistJoinedDate;
    map['patient_joined_date'] = patientJoinedDate;
    map['session_status_confirmed_by_client'] = sessionStatusConfirmedByClient;
    return map;
  }
}
