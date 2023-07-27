import 'package:o7therapy/api/models/booking/therapist_list/therapist_list.dart';
import 'package:o7therapy/api/models/booking/therapists_booked_before/therapists_booked_before_wrapper.dart';
import 'package:o7therapy/api/models/guest_therapist_list/List.dart'
    as therapists_list;
import 'package:o7therapy/api/models/therapist_bio/TherapistBio.dart'
    as therapistBio;
import 'package:o7therapy/ui/screens/home_logged_in/bloc/check_user_discount_cubit/check_user_discount_cubit.dart';

enum ClientStatus { insuranceClient, ewpClient }

class TherapistData {
  TherapistData({
    this.clientStatus,
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
  final ClientStatus? clientStatus;

  factory TherapistData.fromBackEndListElement(ListElement element) =>
      TherapistData(
        currency: element.currency,
        flatRate: element.flatRate,
        isOldClient: element.isOldClient,
        clientInDebt: element.clientInDebt,
        userType: element.userType,
        canPrescribe: element.canPrescribe,
        languages: element.languages != null
            ? List.from(element.languages!.map((x) => x))
            : [],
        tags:
            element.tags != null ? List.from(element.tags!.map((x) => x)) : [],
        id: element.id,
        title: element.title,
        name: element.name,
        profession: element.profession,
        image: element.image?.copyWith(),
        biographyTextSummary: element.biographyTextSummary,
        feesPerSession: element.feesPerSession,
        biographyVideo: element.biographyVideo?.copyWith(),
        firstAvailableSlotDate: element.firstAvailableSlotDate,
        sessionAdvanceNoticePeriod: element.sessionAdvanceNoticePeriod,
        acceptNewClient: element.acceptNewClient,
        yearsOfExperience: element.yearsOfExperience,
        clientStatus: CheckUserDiscountCubit.clientStatus,
      );

  TherapistData copyWith({
    String? currency,
    bool? flatRate,
    bool? isOldClient,
    bool? clientInDebt,
    int? userType,
    bool? canPrescribe,
    List<String>? languages,
    List<String>? tags,
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
    int? yearsOfExperience,
    ClientStatus? clientStatus,
  }) {
    return TherapistData(
      currency: currency ?? this.currency,
      flatRate: flatRate ?? this.flatRate,
      isOldClient: isOldClient ?? this.isOldClient,
      clientInDebt: clientInDebt ?? this.clientInDebt,
      userType: userType ?? this.userType,
      canPrescribe: canPrescribe ?? this.canPrescribe,
      languages: languages ?? this.languages,
      tags: tags ?? this.tags,
      id: id ?? this.id,
      title: title ?? this.title,
      name: name ?? this.name,
      profession: profession ?? this.profession,
      image: image ?? this.image!.copyWith(),
      biographyTextSummary: biographyTextSummary ?? this.biographyTextSummary,
      feesPerSession: feesPerSession ?? this.feesPerSession,
      biographyVideo: biographyVideo ?? this.biographyVideo!.copyWith(),
      firstAvailableSlotDate:
          firstAvailableSlotDate ?? this.firstAvailableSlotDate,
      sessionAdvanceNoticePeriod:
          sessionAdvanceNoticePeriod ?? this.sessionAdvanceNoticePeriod,
      acceptNewClient: acceptNewClient ?? this.acceptNewClient,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      clientStatus: clientStatus ?? this.clientStatus,
    );
  }

  /// from backend but the data here is for booked with before endPoint
  factory TherapistData.fromBackEndBookedBeforeListData(Datum datum) =>
      TherapistData(
        currency: datum.currency,
        flatRate: datum.flatRate,
        isOldClient: datum.isOldClient,
        clientInDebt: datum.clientInDebt,
        userType: datum.userType,
        canPrescribe: datum.canPrescribe,
        languages: datum.languages != null
            ? List.from(datum.languages!.map((x) => x))
            : [],
        tags: datum.tags != null ? List.from(datum.tags!.map((x) => x)) : [],
        id: datum.id,
        title: datum.title,
        name: datum.name,
        profession: datum.profession,
        image: datum.image?.copyWith(),
        biographyTextSummary: datum.biographyTextSummary,
        feesPerSession: datum.feesPerSession?.toDouble(),
        biographyVideo: datum.biographyVideo?.copyWith(),
        firstAvailableSlotDate: datum.firstAvailableSlotDate,
        sessionAdvanceNoticePeriod: datum.sessionAdvanceNoticePeriod,
        acceptNewClient: datum.acceptNewClient,
        yearsOfExperience: datum.yearsOfExperience,
        clientStatus: CheckUserDiscountCubit.clientStatus,
      );

  factory TherapistData.fromBackEndFromTherapistBio(
    therapistBio.TherapistBio bio,
  ) {
    return TherapistData(
      acceptNewClient: bio.data?.acceptNewClient,
      biographyTextSummary: bio.data?.biographyTextSummary,
      biographyVideo: BiographyVideo(
          code: bio.data?.biographyVideo?.code,
          name: bio.data?.biographyVideo?.name,
          url: bio.data?.biographyVideo?.url),
      canPrescribe: bio.data?.canPrescribe,
      clientInDebt: bio.data?.clientInDebt,
      flatRate: bio.data?.flatRate,
      isOldClient: bio.data?.isOldClient,
      languages: bio.data?.languages != null
          ? List.from(bio.data!.languages!.map((x) => x))
          : [],
      tags: bio.data?.tags != null
          ? List.from(bio.data!.tags!.map((x) => x))
          : [],
      title: bio.data?.title,
      userType: bio.data?.userType,
      yearsOfExperience: bio.data?.yearsOfExperience,
      currency: bio.data?.currency,
      id: bio.data?.id,
      name: bio.data?.name,
      profession: bio.data?.profession,
      image: Image(
        url: bio.data?.image?.url,
        imageCode: bio.data?.image?.imageCode,
      ),
      feesPerSession: bio.data?.feesPerSession?.toDouble(),
      firstAvailableSlotDate: bio.data?.firstAvailableSlotDate,
      sessionAdvanceNoticePeriod: bio.data?.sessionAdvanceNoticePeriod,
      clientStatus: CheckUserDiscountCubit.clientStatus,
    );
  }

  factory TherapistData.fromBackEndTherapistListGuest(
      therapists_list.TherapistsList therapistsList) {
    return TherapistData(
      acceptNewClient: therapistsList.acceptNewClient,
      biographyTextSummary: therapistsList.biographyTextSummary,
      biographyVideo: BiographyVideo(
          code: therapistsList.biographyVideo?.code,
          name: therapistsList.biographyVideo?.name,
          url: therapistsList.biographyVideo?.url),
      canPrescribe: therapistsList.canPrescribe,
      languages: therapistsList.languages != null
          ? List.from(therapistsList.languages!.map((x) => x))
          : [],
      tags: therapistsList.tags != null
          ? List.from(therapistsList.tags!.map((x) => x))
          : [],
      title: therapistsList.title,
      yearsOfExperience: therapistsList.yearsOfExperience?.toInt(),
      currency: therapistsList.currency,
      id: therapistsList.id,
      name: therapistsList.name,
      profession: therapistsList.profession,
      image: Image(
        url: therapistsList.image?.url,
        imageCode: therapistsList.image?.imageCode,
      ),
      feesPerSession: therapistsList.feesPerSession?.toDouble(),
      firstAvailableSlotDate: therapistsList.firstAvailableSlotDate,
    );
  }
  @override
  String toString() {
    return 'TherapistData(currency: $currency, flatRate: $flatRate, isOldClient: $isOldClient, clientInDebt: $clientInDebt, userType: $userType, canPrescribe: $canPrescribe, languages: $languages, tags: $tags, id: $id, title: $title, name: $name, profession: $profession, image: $image, biographyTextSummary: $biographyTextSummary, feesPerSession: $feesPerSession, biographyVideo: $biographyVideo, firstAvailableSlotDate: $firstAvailableSlotDate, sessionAdvanceNoticePeriod: $sessionAdvanceNoticePeriod, acceptNewClient: $acceptNewClient, yearsOfExperience: $yearsOfExperience, clientStatus: $clientStatus)';
  }
}
