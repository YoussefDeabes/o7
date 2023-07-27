part of 'therapist_profile_bloc.dart';

abstract class TherapistProfileEvent {
  const TherapistProfileEvent();
}

class OneOnOneSelected extends TherapistProfileEvent {
  const OneOnOneSelected();
}

class CouplesTherapySelected extends TherapistProfileEvent {
  const CouplesTherapySelected();
}

class DrugReviewSelected extends TherapistProfileEvent {
  const DrugReviewSelected();
}

class ClinicalAssessmentSelected extends TherapistProfileEvent {
  const ClinicalAssessmentSelected();
}

class BookASessionClicked extends TherapistProfileEvent {
  String availableSlotId;
  String slotDate;

  BookASessionClicked(this.availableSlotId, this.slotDate);
}

class CheckHasSessions extends TherapistProfileEvent {
  String availableSlotId;
  String slotDate;

  CheckHasSessions(this.availableSlotId, this.slotDate);
}

class CheckHasInsuranceFlatRate extends TherapistProfileEvent {
  String availableSlotId;
  String slotDate;

  CheckHasInsuranceFlatRate(this.availableSlotId, this.slotDate);
}

class CheckIsCorporate extends TherapistProfileEvent {
  String availableSlotId;
  String slotDate;

  CheckIsCorporate(this.availableSlotId, this.slotDate);
}

class CheckIsInsurance extends TherapistProfileEvent {
  String availableSlotId;
  String slotDate;

  CheckIsInsurance(this.availableSlotId, this.slotDate);
}

class AccumulativeSessionFeesEvent extends TherapistProfileEvent {}

class RequestASessionEvent extends TherapistProfileEvent {
  String id;

  RequestASessionEvent(this.id);
}

class JoinWaitListEvent extends TherapistProfileEvent {
  String id;

  JoinWaitListEvent(this.id);
}
