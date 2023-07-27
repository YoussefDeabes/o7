import 'Image.dart';
import 'BiographyVideo.dart';

/// currency : "USD"
/// can_prescribe : true
/// languages : ["Arabic","English"]
/// tags : ["stress","Anxiety","dewdwe","couple","hello","art therapys tag","Maternal Mental Health","Anger Management","sdfsdf","Suscipit debitis sun","type of 2","type of 3","type of 4","type of 5"]
/// id : "4f878040-b809-421d-9fac-6c9e228425d3"
/// title : ""
/// name : "mido min"
/// profession : "sadasd"
/// image : {"image_code":"IMG_2021-06-10-12_84943.png","url":"/api/identity/imgapi/IMG_2021-06-10-12_84943.png"}
/// biography_text_summary : "werwer"
/// fees_per_session : 300.0
/// biography_video : {"url":"https://www.youtube.com/embed/j1gU2oGFayY","code":null,"name":null}
/// first_available_slot_date : "20221212120000"
/// session_advance_notice_period : 0
/// accept_new_client : true
/// years_of_experience : 5

class TherapistsList {
  TherapistsList({
      this.currency, 
      this.canPrescribe, 
      this.languages, 
      this.tags, 
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
      this.yearsOfExperience,});

  TherapistsList.fromJson(dynamic json) {
    currency = json['currency'];
    canPrescribe = json['can_prescribe'];
    languages = json['languages'] != null ? json['languages'].cast<String>() : [];
    tags = json['tags'] != null ? json['tags'].cast<String>() : [];
    id = json['id'];
    title = json['title'];
    name = json['name'];
    profession = json['profession'];
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
    biographyTextSummary = json['biography_text_summary'];
    feesPerSession = json['fees_per_session'];
    biographyVideo = json['biography_video'] != null ? BiographyVideo.fromJson(json['biography_video']) : null;
    firstAvailableSlotDate = json['first_available_slot_date'];
    sessionAdvanceNoticePeriod = json['session_advance_notice_period'];
    acceptNewClient = json['accept_new_client'];
    yearsOfExperience = json['years_of_experience'];
  }
  String? currency;
  bool? canPrescribe;
  List<String>? languages;
  List<String>? tags;
  String? id;
  String? title;
  String? name;
  String? profession;
  Image? image;
  String? biographyTextSummary;
  num? feesPerSession;
  BiographyVideo? biographyVideo;
  String? firstAvailableSlotDate;
  num? sessionAdvanceNoticePeriod;
  bool? acceptNewClient;
  num? yearsOfExperience;
  TherapistsList copyWith({  String? currency,
  bool? canPrescribe,
  List<String>? languages,
  List<String>? tags,
  String? id,
  String? title,
  String? name,
  String? profession,
  Image? image,
  String? biographyTextSummary,
  num? feesPerSession,
  BiographyVideo? biographyVideo,
  String? firstAvailableSlotDate,
  num? sessionAdvanceNoticePeriod,
  bool? acceptNewClient,
  num? yearsOfExperience,
}) => TherapistsList(  currency: currency ?? this.currency,
  canPrescribe: canPrescribe ?? this.canPrescribe,
  languages: languages ?? this.languages,
  tags: tags ?? this.tags,
  id: id ?? this.id,
  title: title ?? this.title,
  name: name ?? this.name,
  profession: profession ?? this.profession,
  image: image ?? this.image,
  biographyTextSummary: biographyTextSummary ?? this.biographyTextSummary,
  feesPerSession: feesPerSession ?? this.feesPerSession,
  biographyVideo: biographyVideo ?? this.biographyVideo,
  firstAvailableSlotDate: firstAvailableSlotDate ?? this.firstAvailableSlotDate,
  sessionAdvanceNoticePeriod: sessionAdvanceNoticePeriod ?? this.sessionAdvanceNoticePeriod,
  acceptNewClient: acceptNewClient ?? this.acceptNewClient,
  yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['currency'] = currency;
    map['can_prescribe'] = canPrescribe;
    map['languages'] = languages;
    map['tags'] = tags;
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
    map['years_of_experience'] = yearsOfExperience;
    return map;
  }

}