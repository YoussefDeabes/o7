part of 'group_assessment_promo_code_bloc.dart';

abstract class GroupAssessmentPromoCodeState extends Equatable {
  const GroupAssessmentPromoCodeState();

  @override
  List<Object> get props => [];
}

class GroupAssessmentPromoCodeInitial extends GroupAssessmentPromoCodeState {
  const GroupAssessmentPromoCodeInitial();
}

class LoadingGroupAssessmentPromoCode extends GroupAssessmentPromoCodeState {
  const LoadingGroupAssessmentPromoCode();
}

class FailedGroupAssessmentPromoCode extends GroupAssessmentPromoCodeState {
  const FailedGroupAssessmentPromoCode();
}

class VerifiedGroupAssessmentPromoCode extends GroupAssessmentPromoCodeState {
  final PromoCode promoCode;
  const VerifiedGroupAssessmentPromoCode(this.promoCode);
}

class ErrorGroupAssessmentState extends GroupAssessmentPromoCodeState {
  final String message;
  const ErrorGroupAssessmentState(this.message);
}
