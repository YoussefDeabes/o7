import 'package:o7therapy/api/models/booking/therapist_list/therapist_list.dart';

class TherapistsBookedBeforeWrapper {
  TherapistsBookedBeforeWrapper({
    required this.data,
    required this.errorCode,
    required this.errorMsg,
    required this.errorDetails,
    required this.expiration,
    required this.persistence,
    required this.totalSeconds,
  });

  final List<Datum>? data;
  final int? errorCode;
  final String? errorMsg;
  final String? errorDetails;
  final Expiration? expiration;
  final Persistence? persistence;
  final int? totalSeconds;

  factory TherapistsBookedBeforeWrapper.fromJson(Map<String, dynamic> json) =>
      TherapistsBookedBeforeWrapper(
        data: json['data'] != null
            ? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x)))
            : null,
        errorCode: json["error_code"],
        errorMsg: json["error_msg"],
        errorDetails: json["error_details"],
        expiration: json['expiration'] != null
            ? Expiration.fromJson(json['expiration'])
            : null,
        persistence: json['persistence'] != null
            ? Persistence.fromJson(json['persistence'])
            : null,
        totalSeconds: json["total_seconds"],
      );
}

class Datum {
  Datum({
    required this.biographyText,
    required this.yearsOfExperience,
    required this.feesPerInternationalSession,
    required this.specialtiesIds,
    required this.tagsIds,
    required this.languagesIds,
    required this.canAssess,
    required this.canPrescribe,
    required this.therapistTags,
    required this.therapistCurrencies,
    required this.currency,
    required this.flatRate,
    required this.isOldClient,
    required this.clientInDebt,
    required this.userType,
    required this.languages,
    required this.tags,
    required this.id,
    required this.title,
    required this.name,
    required this.profession,
    required this.image,
    required this.biographyTextSummary,
    required this.feesPerSession,
    required this.biographyVideo,
    required this.firstAvailableSlotDate,
    required this.sessionAdvanceNoticePeriod,
    required this.acceptNewClient,
  });

  final String? biographyText;
  final int? yearsOfExperience;
  final double? feesPerInternationalSession;
  final List<int>? specialtiesIds;
  final List<int>? tagsIds;
  final List<int>? languagesIds;
  final bool? canAssess;
  final bool? canPrescribe;
  final List<TherapistTag>? therapistTags;
  final List<TherapistCurrency>? therapistCurrencies;
  final String? currency;
  final bool? flatRate;
  final bool? isOldClient;
  final bool? clientInDebt;
  final int? userType;
  final List<String>? languages;
  final List<String>? tags;
  final String? id;
  final String? title;
  final String? name;
  final String? profession;
  final Image? image;
  final String? biographyTextSummary;
  final double? feesPerSession;
  final BiographyVideo? biographyVideo;
  final String? firstAvailableSlotDate;
  final int? sessionAdvanceNoticePeriod;
  final bool? acceptNewClient;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        biographyText: json["biography_text"],
        yearsOfExperience: json["years_of_experience"],
        feesPerInternationalSession: json["fees_per_international_session"],
        specialtiesIds: List<int>.from(json["specialties_ids"].map((x) => x)),
        tagsIds: List<int>.from(json["tags_ids"].map((x) => x)),
        languagesIds: List<int>.from(json["languages_ids"].map((x) => x)),
        canAssess: json["can_assess"],
        canPrescribe: json["can_prescribe"],
        therapistTags: List<TherapistTag>.from(
            json["therapist_tags"].map((x) => TherapistTag.fromJson(x))),
        therapistCurrencies: List<TherapistCurrency>.from(
            json["therapist_currencies"]
                .map((x) => TherapistCurrency.fromJson(x))),
        currency: json["currency"],
        flatRate: json["flat_rate"],
        isOldClient: json["is_old_client"],
        clientInDebt: json["client_in_debt"],
        userType: json["user_type"],
        languages: List<String>.from(json["languages"].map((x) => x)),
        tags: json["tags"] != null
            ? List.from(json["tags"].map((x) => x ?? ''))
            : [],
        id: json["id"],
        title: json["title"],
        name: json["name"],
        profession: json["profession"],
        image: Image.fromJson(json["image"]),
        biographyTextSummary: json["biography_text_summary"],
        feesPerSession: json["fees_per_session"],
        biographyVideo: BiographyVideo.fromJson(json["biography_video"]),
        firstAvailableSlotDate: json["first_available_slot_date"],
        sessionAdvanceNoticePeriod: json["session_advance_notice_period"],
        acceptNewClient: json["accept_new_client"],
      );
}

class TherapistCurrency {
  TherapistCurrency({
    required this.therapistId,
    required this.currencyId,
    required this.currency,
    required this.value,
  });

  final String? therapistId;
  final int? currencyId;
  final String? currency;
  final int? value;

  factory TherapistCurrency.fromJson(Map<String, dynamic> json) =>
      TherapistCurrency(
        therapistId: json["therapist_id"],
        currencyId: json["currency_id"],
        currency: json["currency"],
        value: json["value"],
      );
}

class TherapistTag {
  TherapistTag({
    required this.titleEn,
    required this.titleAr,
    required this.groupNameEn,
    required this.groupNameAr,
  });

  final String? titleEn;
  final String? titleAr;
  final String? groupNameEn;
  final String? groupNameAr;

  factory TherapistTag.fromJson(Map<String, dynamic> json) => TherapistTag(
        titleEn: json["title_en"],
        titleAr: json["title_ar"],
        groupNameEn: json["group_name_en"],
        groupNameAr: json["group_name_ar"],
      );
}
