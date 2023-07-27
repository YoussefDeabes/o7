import 'package:o7therapy/ui/screens/therapist_profile/bloc/therapist_profile_bloc.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

enum ProfileCategories {
  bio(
    translatedKey: LangKeys.bio,
    // therapistProfileEvent: BioSelected()
  ),
  schedule(
    translatedKey: LangKeys.schedule,
    // therapistProfileEvent: ScheduleSelected("")
  );
  // services(
  //   translatedKey: LangKeys.services,
  //   // therapistProfileEvent: ServicesSelected(),
  // ),
  // reviews(
  //   translatedKey: LangKeys.reviews,
  //   // therapistProfileEvent: ReviewsSelected(),
  // ),
  // videos(
  //   translatedKey: LangKeys.videos,
  //   // therapistProfileEvent: VideosSelected(),
  // ),
  // blogs(
  //   translatedKey: LangKeys.blogs,
  //   // therapistProfileEvent: BlogsSelected(),
  // );

  const ProfileCategories({
    required this.translatedKey,
    // required this.therapistProfileEvent,
  });

  final String translatedKey;
  // final TherapistProfileEvent therapistProfileEvent;
}

enum SessionTypes {
  oneOnOne(
      translatedKey: LangKeys.oneOnOne,
      therapistProfileEvent: OneOnOneSelected()),
  coupleTherapy(
      translatedKey: LangKeys.coupleTherapy,
      therapistProfileEvent: CouplesTherapySelected()),
  drugReview(
    translatedKey: LangKeys.drugReview,
    therapistProfileEvent: DrugReviewSelected(),
  ),
  clinicalAssessment(
    translatedKey: LangKeys.clinicalAssessment,
    therapistProfileEvent: ClinicalAssessmentSelected(),
  );

  const SessionTypes({
    required this.translatedKey,
    required this.therapistProfileEvent,
  });

  final String translatedKey;
  final TherapistProfileEvent therapistProfileEvent;
}
