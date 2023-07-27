import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/api/models/promo_code/PromoCode.dart';
import 'package:o7therapy/ui/screens/group_assessment/bloc/group_assessment_promo_code_bloc/group_assessment_promo_code_repo.dart';

part 'group_assessment_promo_code_event.dart';
part 'group_assessment_promo_code_state.dart';

class GroupAssessmentPromoCodeBloc
    extends Bloc<GroupAssessmentPromoCodeEvent, GroupAssessmentPromoCodeState> {
  final BaseGroupAssessmentPromoCodeRepo _repo;
  GroupAssessmentPromoCodeBloc(this._repo)
      : super(const GroupAssessmentPromoCodeInitial()) {
    on<GroupAssessmentPromoCodeEvent>(_onGroupAssessmentPromoCodeEvent);
  }
  static GroupAssessmentPromoCodeBloc bloc(BuildContext context) =>
      context.read<GroupAssessmentPromoCodeBloc>();

  FutureOr<void> _onGroupAssessmentPromoCodeEvent(
    GroupAssessmentPromoCodeEvent event,
    Emitter<GroupAssessmentPromoCodeState> emit,
  ) async {
    emit(const LoadingGroupAssessmentPromoCode());
    emit(await _repo.verifyPromoCode(event.promoCode, event.slotId));
  }
}
