import 'biography_video.dart';
import 'image.dart';

class ListElement {
  ListElement({
    this.currency,
    this.flatRate,
    this.isOldClient,
    this.clientInDebt,
    this.userType,
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
    this.yearsOfExperience,
  });

  final String? currency;
  final bool? flatRate;
  final bool? isOldClient;
  final bool? clientInDebt;
  final int? userType;
  final bool? canPrescribe;
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
  final int? yearsOfExperience;

  factory ListElement.fromJson(json) => ListElement(
        currency: json["currency"],
        flatRate: json["flat_rate"],
        isOldClient: json["is_old_client"],
        clientInDebt: json["client_in_debt"],
        userType: json["user_type"],
        canPrescribe: json["can_prescribe"],
        languages: json["languages"] != null
            ? List.from(json["languages"].map((x) => x ?? ''))
            : [],
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
        yearsOfExperience: json["years_of_experience"],
      );

  Map<String, dynamic> toJson() => {
        "currency": currency,
        "flat_rate": flatRate,
        "is_old_client": isOldClient,
        "client_in_debt": clientInDebt,
        "user_type": userType,
        "can_prescribe": canPrescribe,
        "languages": languages == null
            ? null
            : List<String>.from(languages!.map((x) => x)),
        "tags": tags == null ? null : List<String>.from(tags!.map((x) => x)),
        "id": id,
        "title": title,
        "name": name,
        "profession": profession,
        "image": image?.toJson(),
        "biography_text_summary": biographyTextSummary,
        "fees_per_session": feesPerSession,
        "biography_video": biographyVideo?.toJson(),
        "first_available_slot_date": firstAvailableSlotDate,
        "session_advance_notice_period": sessionAdvanceNoticePeriod,
        "accept_new_client": acceptNewClient,
        "years_of_experience": yearsOfExperience,
      };
}
