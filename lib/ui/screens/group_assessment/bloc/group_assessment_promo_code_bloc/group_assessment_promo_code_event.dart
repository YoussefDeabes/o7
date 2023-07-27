part of 'group_assessment_promo_code_bloc.dart';

class GroupAssessmentPromoCodeEvent extends Equatable {
  final String promoCode;
  final String slotId;

  const GroupAssessmentPromoCodeEvent(this.promoCode, this.slotId);

  @override
  List<Object> get props => [];
}
