import 'TherapistTags.dart';
import 'TherapistCurrencies.dart';
import 'Image.dart';
import 'BiographyVideo.dart';

/// biography_text : "string"
/// years_of_experience : 0
/// fees_per_international_session : 0
/// specialties_ids : [0]
/// tags_ids : [0]
/// languages_ids : [0]
/// can_assess : true
/// can_prescribe : true
/// therapist_tags : [{"title_en":"string","title_ar":"string","group_name_en":"string","group_name_ar":"string"}]
/// therapist_currencies : [{"therapist_id":"string","currency_id":0,"currency":{"id":0,"currency_code":"string","currency_name_ar":"string","currency_name_en":"string"},"value":0}]
/// currency : "string"
/// flat_rate : true
/// is_old_client : true
/// client_in_debt : true
/// id : "string"
/// title : "string"
/// name : "string"
/// profession : "string"
/// image : {"image_code":"string","url":"string"}
/// biography_text_summary : "string"
/// fees_per_session : 0
/// biography_video : {"url":"string","code":"string","name":"string"}
/// first_available_slot_date : "string"
/// session_advance_notice_period : 0
/// accept_new_client : true

class Data {
  Data({
    this.userType,
    this.languages,
    this.tags,
    this.biographyText,
    this.yearsOfExperience,
    this.feesPerInternationalSession,
    this.specialtiesIds,
    this.tagsIds,
    this.languagesIds,
    this.canAssess,
    this.canPrescribe,
    this.therapistTags,
    this.therapistCurrencies,
    this.currency,
    this.flatRate,
    this.isOldClient,
    this.clientInDebt,
    this.id,
    this.title,
    this.name,
    this.profession,
    this.image,
    this.biographyTextSummary,
    this.feesPerSession,
    this.biographyVideo,
    this.firstAvailableSlotDate,
    this.sessionAdvanceNoticePeriod,
    this.acceptNewClient,
  });

  Data.fromJson(dynamic json) {
    languages =
        json['languages'] != null ? json['languages'].cast<String>() : [];
    userType = json["user_type"];
    tags = json['tags'] != null ? json['tags'].cast<String>() : [];

    biographyText = json['biography_text'];
    yearsOfExperience = json['years_of_experience'];
    feesPerInternationalSession = json['fees_per_international_session'];
    specialtiesIds = json['specialties_ids'] != null
        ? json['specialties_ids'].cast<int>()
        : [];
    tagsIds = json['tags_ids'] != null ? json['tags_ids'].cast<int>() : [];
    languagesIds =
        json['languages_ids'] != null ? json['languages_ids'].cast<int>() : [];
    canAssess = json['can_assess'];
    canPrescribe = json['can_prescribe'];
    if (json['therapist_tags'] != null) {
      therapistTags = [];
      json['therapist_tags'].forEach((v) {
        therapistTags?.add(TherapistTags.fromJson(v));
      });
    }
    if (json['therapist_currencies'] != null) {
      therapistCurrencies = [];
      json['therapist_currencies'].forEach((v) {
        therapistCurrencies?.add(TherapistCurrencies.fromJson(v));
      });
    }
    currency = json['currency'];
    flatRate = json['flat_rate'];
    isOldClient = json['is_old_client'];
    clientInDebt = json['client_in_debt'];
    id = json['id'];
    title = json['title'];
    name = json['name'];
    profession = json['profession'];
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
    biographyTextSummary = json['biography_text_summary'];
    feesPerSession = json['fees_per_session'];
    biographyVideo = json['biography_video'] != null
        ? BiographyVideo.fromJson(json['biography_video'])
        : null;
    firstAvailableSlotDate = json['first_available_slot_date'];
    sessionAdvanceNoticePeriod = json['session_advance_notice_period'];
    acceptNewClient = json['accept_new_client'];
  }

  String? biographyText;
  int? yearsOfExperience;
  double? feesPerInternationalSession;
  List<int>? specialtiesIds;
  List<int>? tagsIds;
  List<int>? languagesIds;
  bool? canAssess;
  bool? canPrescribe;
  List<TherapistTags>? therapistTags;
  List<TherapistCurrencies>? therapistCurrencies;
  String? currency;
  bool? flatRate;
  bool? isOldClient;
  bool? clientInDebt;
  String? id;
  String? title;
  String? name;
  String? profession;
  Image? image;
  String? biographyTextSummary;
  double? feesPerSession;
  BiographyVideo? biographyVideo;
  String? firstAvailableSlotDate;
  int? sessionAdvanceNoticePeriod;
  bool? acceptNewClient;
  int? userType;
  List<String>? languages;
  List<String>? tags;

  Data copyWith({
    String? biographyText,
    int? yearsOfExperience,
    double? feesPerInternationalSession,
    List<int>? specialtiesIds,
    List<int>? tagsIds,
    List<int>? languagesIds,
    bool? canAssess,
    bool? canPrescribe,
    List<TherapistTags>? therapistTags,
    List<TherapistCurrencies>? therapistCurrencies,
    String? currency,
    bool? flatRate,
    bool? isOldClient,
    bool? clientInDebt,
    String? id,
    String? title,
    String? name,
    String? profession,
    Image? image,
    String? biographyTextSummary,
    double? feesPerSession,
    BiographyVideo? biographyVideo,
    String? firstAvailableSlotDate,
    int? sessionAdvanceNoticePeriod,
    bool? acceptNewClient,
    int? userType,
    List<String>? languages,
    List<String>? tags,
  }) =>
      Data(
        userType: userType ?? this.userType,
        languages: languages ?? this.languages,
        tags: tags ?? this.tags,
        biographyText: biographyText ?? this.biographyText,
        yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
        feesPerInternationalSession:
            feesPerInternationalSession ?? this.feesPerInternationalSession,
        specialtiesIds: specialtiesIds ?? this.specialtiesIds,
        tagsIds: tagsIds ?? this.tagsIds,
        languagesIds: languagesIds ?? this.languagesIds,
        canAssess: canAssess ?? this.canAssess,
        canPrescribe: canPrescribe ?? this.canPrescribe,
        therapistTags: therapistTags ?? this.therapistTags,
        therapistCurrencies: therapistCurrencies ?? this.therapistCurrencies,
        currency: currency ?? this.currency,
        flatRate: flatRate ?? this.flatRate,
        isOldClient: isOldClient ?? this.isOldClient,
        clientInDebt: clientInDebt ?? this.clientInDebt,
        id: id ?? this.id,
        title: title ?? this.title,
        name: name ?? this.name,
        profession: profession ?? this.profession,
        image: image ?? this.image,
        biographyTextSummary: biographyTextSummary ?? this.biographyTextSummary,
        feesPerSession: feesPerSession ?? this.feesPerSession,
        biographyVideo: biographyVideo ?? this.biographyVideo,
        firstAvailableSlotDate:
            firstAvailableSlotDate ?? this.firstAvailableSlotDate,
        sessionAdvanceNoticePeriod:
            sessionAdvanceNoticePeriod ?? this.sessionAdvanceNoticePeriod,
        acceptNewClient: acceptNewClient ?? this.acceptNewClient,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["user_type"] = userType;
    map['languages'] = languages;
    map['tags'] = tags;
    map['biography_text'] = biographyText;
    map['years_of_experience'] = yearsOfExperience;
    map['fees_per_international_session'] = feesPerInternationalSession;
    map['specialties_ids'] = specialtiesIds;
    map['tags_ids'] = tagsIds;
    map['languages_ids'] = languagesIds;
    map['can_assess'] = canAssess;
    map['can_prescribe'] = canPrescribe;
    if (therapistTags != null) {
      map['therapist_tags'] = therapistTags?.map((v) => v.toJson()).toList();
    }
    if (therapistCurrencies != null) {
      map['therapist_currencies'] =
          therapistCurrencies?.map((v) => v.toJson()).toList();
    }
    map['currency'] = currency;
    map['flat_rate'] = flatRate;
    map['is_old_client'] = isOldClient;
    map['client_in_debt'] = clientInDebt;
    map['id'] = id;
    map['title'] = title;
    map['name'] = name;
    map['profession'] = profession;
    if (image != null) {
      map['image'] = image?.toJson();
    }
    map['biography_text_summary'] = biographyTextSummary;
    map['fees_per_session'] = feesPerSession;
    if (biographyVideo != null) {
      map['biography_video'] = biographyVideo?.toJson();
    }
    map['first_available_slot_date'] = firstAvailableSlotDate;
    map['session_advance_notice_period'] = sessionAdvanceNoticePeriod;
    map['accept_new_client'] = acceptNewClient;
    return map;
  }
}
