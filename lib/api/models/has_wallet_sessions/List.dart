import 'TherapistImage.dart';
import 'PatientWallet.dart';

/// therapist_id : "0e8d8019-5b1a-499c-92ea-a564550eeab6"
/// therapist_name : "Zaina Hossam"
/// therapist_profession : "En"
/// therapist_image : {"image_code":"IMG_2021-06-14-10_44160.png","url":"/api/identity/imgapi/IMG_2021-06-14-10_44160.png"}
/// fees_per_session : 6000.00
/// fees_per_international_session : 9000.00
/// first_available_slot_date : null
/// session_advance_notice_period : null
/// currency : "EGP"
/// patient_wallet : [{"id":19,"duration":50.00}]

class HasWalletSessionsList {
  HasWalletSessionsList({
    this.therapistId,
    this.therapistName,
    this.therapistNameAr,
    this.therapistProfession,
    this.therapistProfessionAr,
    this.therapistImage,
    this.feesPerSession,
    this.feesPerInternationalSession,
    this.firstAvailableSlotDate,
    this.sessionAdvanceNoticePeriod,
    this.currency,
    this.patientWallet,
  });

  HasWalletSessionsList.fromJson(dynamic json) {
    therapistId = json['therapist_id'];
    therapistName = json['therapist_name'];
    therapistNameAr = json['therapist_name_ar'];
    therapistProfession = json['therapist_profession'];
    therapistProfessionAr = json['therapist_profession_ar'];
    therapistImage = json['therapist_image'] != null
        ? TherapistImage.fromJson(json['therapist_image'])
        : null;
    feesPerSession = json['fees_per_session'];
    feesPerInternationalSession = json['fees_per_international_session'];
    firstAvailableSlotDate = json['first_available_slot_date'];
    sessionAdvanceNoticePeriod = json['session_advance_notice_period'];
    currency = json['currency'];
    if (json['patient_wallet'] != null) {
      patientWallet = [];
      json['patient_wallet'].forEach((v) {
        patientWallet?.add(PatientWallet.fromJson(v));
      });
    }
  }

  String? therapistId;
  String? therapistName;
  String? therapistNameAr;
  String? therapistProfession;
  String? therapistProfessionAr;
  TherapistImage? therapistImage;
  double? feesPerSession;
  double? feesPerInternationalSession;
  String? firstAvailableSlotDate;
  int? sessionAdvanceNoticePeriod;
  String? currency;
  List<PatientWallet>? patientWallet;

  HasWalletSessionsList copyWith({
    String? therapistId,
    String? therapistName,
    String? therapistNameAr,
    String? therapistProfession,
    String? therapistProfessionAr,
    TherapistImage? therapistImage,
    double? feesPerSession,
    double? feesPerInternationalSession,
    String? firstAvailableSlotDate,
    int? sessionAdvanceNoticePeriod,
    String? currency,
    List<PatientWallet>? patientWallet,
  }) =>
      HasWalletSessionsList(
        therapistId: therapistId ?? this.therapistId,
        therapistName: therapistName ?? this.therapistName,
        therapistNameAr: therapistNameAr ?? this.therapistNameAr,
        therapistProfession: therapistProfession ?? this.therapistProfession,
        therapistProfessionAr:
            therapistProfessionAr ?? this.therapistProfessionAr,
        therapistImage: therapistImage ?? this.therapistImage,
        feesPerSession: feesPerSession ?? this.feesPerSession,
        feesPerInternationalSession:
            feesPerInternationalSession ?? this.feesPerInternationalSession,
        firstAvailableSlotDate:
            firstAvailableSlotDate ?? this.firstAvailableSlotDate,
        sessionAdvanceNoticePeriod:
            sessionAdvanceNoticePeriod ?? this.sessionAdvanceNoticePeriod,
        currency: currency ?? this.currency,
        patientWallet: patientWallet ?? this.patientWallet,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['therapist_id'] = therapistId;
    map['therapist_name'] = therapistName;
    map['therapist_name_ar'] = therapistNameAr;
    map['therapist_profession'] = therapistProfession;
    map['therapist_profession_ar'] = therapistProfessionAr;
    if (therapistImage != null) {
      map['therapist_image'] = therapistImage?.toJson();
    }
    map['fees_per_session'] = feesPerSession;
    map['fees_per_international_session'] = feesPerInternationalSession;
    map['first_available_slot_date'] = firstAvailableSlotDate;
    map['session_advance_notice_period'] = sessionAdvanceNoticePeriod;
    map['currency'] = currency;
    if (patientWallet != null) {
      map['patient_wallet'] = patientWallet?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
