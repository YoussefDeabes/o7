part of 'therapist_profile_bloc.dart';

@immutable
abstract class TherapistProfileState {
  const TherapistProfileState();
}

class TherapistProfileInitial extends TherapistProfileState {
  const TherapistProfileInitial();
}

class NetworkError extends TherapistProfileState {
  final String message;

  const NetworkError(this.message);
}

class ErrorState extends TherapistProfileState {
  final String message;

  const ErrorState(this.message);
}

class LoadingTherapistProfile extends TherapistProfileState {
  const LoadingTherapistProfile();
}

class ProfileState extends TherapistProfileState {
  final TherapistModel profile;

  const ProfileState({required this.profile});
}

class ClientDiscountsState extends TherapistProfileState {
  final UserDiscounts user;
  final String slotDate;
  final String slotId;

  const ClientDiscountsState(this.user, this.slotId, this.slotDate);
}

class ClientInDebtState extends TherapistProfileState {
  final ClientInDebtWrapper indebt;
  final String slotDate;
  final String slotId;

  ClientInDebtState(this.indebt, this.slotDate, this.slotId);
}

class AccumulativeSessionFeesState extends TherapistProfileState {
  final AccumulativeSessionFees accumulativeSessionFees;

  const AccumulativeSessionFeesState(this.accumulativeSessionFees);
}

class FailClientInDebtState extends TherapistProfileState {
  final String slotDate;
  final String slotId;

  const FailClientInDebtState(this.slotDate, this.slotId);
}

class HasWalletSessionsState extends TherapistProfileState {
  final VerifyWalletSessions hasWalletSessions;
  final String slotDate;
  final String slotId;

  const HasWalletSessionsState(
      this.hasWalletSessions, this.slotDate, this.slotId);
}

class FailHasWalletSessionsState extends TherapistProfileState {
  final String slotDate;
  final String slotId;

  const FailHasWalletSessionsState(this.slotDate, this.slotId);
}

class InsuranceFlatRateState extends TherapistProfileState {
  final String slotDate;
  final String slotId;

  const InsuranceFlatRateState(this.slotId, this.slotDate);
}

class FailInsuranceFlatRateState extends TherapistProfileState {
  final String slotDate;
  final String slotId;

  const FailInsuranceFlatRateState(this.slotDate, this.slotId);
}

class CorporateFlatRateState extends TherapistProfileState {
  final String slotId;
  final String slotDate;

  const CorporateFlatRateState(this.slotId, this.slotDate);
}

class FailCorporateFlatRateState extends TherapistProfileState {
  final String slotDate;
  final String slotId;

  const FailCorporateFlatRateState(this.slotDate, this.slotId);
}

class CorporateState extends TherapistProfileState {
  final CorporateDeal corporateDeal;
  final String slotId;
  final String slotDate;

  const CorporateState(this.corporateDeal, this.slotId, this.slotDate);
}

class FailCorporateState extends TherapistProfileState {
  final String slotDate;
  final String slotId;

  const FailCorporateState(this.slotDate, this.slotId);
}

class InsuranceState extends TherapistProfileState {
  final InsuranceDeal insuranceDeal;
  final String slotId;
  final String slotDate;

  const InsuranceState(this.insuranceDeal, this.slotId, this.slotDate);
}

class FailInsuranceState extends TherapistProfileState {
  final String slotDate;
  final String slotId;

  const FailInsuranceState(this.slotDate, this.slotId);
}

class NormalClientState extends TherapistProfileState {
  final String slotDate;
  final String slotId;

  const NormalClientState(this.slotDate, this.slotId);
}

class RequestASessionState extends TherapistProfileState {
  const RequestASessionState();
}

class JoinWaitListState extends TherapistProfileState {
  const JoinWaitListState();
}

abstract class SessionTypesState extends TherapistProfileState {
  const SessionTypesState();

  SessionTypes get sessionTypes;
}

class OneOnOneSessionState extends SessionTypesState {
  const OneOnOneSessionState();

  @override
  SessionTypes get sessionTypes => SessionTypes.oneOnOne;
}

class CoupleTherapyState extends SessionTypesState {
  const CoupleTherapyState();

  @override
  SessionTypes get sessionTypes => SessionTypes.coupleTherapy;
}

class DrugReviewState extends SessionTypesState {
  const DrugReviewState();

  @override
  SessionTypes get sessionTypes => SessionTypes.drugReview;
}

class ClinicalAssessmentState extends SessionTypesState {
  const ClinicalAssessmentState();

  @override
  SessionTypes get sessionTypes => SessionTypes.clinicalAssessment;
}
