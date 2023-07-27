import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:o7therapy/api/models/guest_therapist_list/List.dart';
import 'package:o7therapy/ui/screens/booking/models/therapist_data.dart';
import 'package:o7therapy/ui/screens/booking_guest/bloc/services_guest_repo.dart';
import 'package:overlay_support/overlay_support.dart';

part 'services_guest_event.dart';

part 'services_guest_state.dart';

class ServicesGuestBloc extends Bloc<ServicesGuestEvent, ServicesGuestState> {
  final BaseGuestServicesRepo _baseRepo;

  ServicesGuestBloc(this._baseRepo) : super(ServicesGuestInitial()) {
    on<OneOnSessionsTabEvt>(_onOneOnOneSelected);
    on<GroupTherapyTabEvt>(_onGroupTherapySelected);
    on<WorkshopsTabEvt>(_onWorkshopsSelected);
    on<ProgramsTabEvt>(_onProgramsSelected);
    on<CouplesTherapyTabEvt>(_onCouplesTherapySelected);
    on<AssessmentAndTestingTabEvt>(_onAssessmentAndTestingSelected);
    on<GetStartedClickedEvt>(_onGetStartedSelected);
    on<ShowMoreGroupTherapyClickedEvt>(_onShowMoreGroupTherapySelected);
    on<ShowMoreWorkshopsClickedEvt>(_onShowMoreWorkshopsSelected);
  }

  _onOneOnOneSelected(OneOnSessionsTabEvt event, emit) async {
    emit( ServicesGuestOneOnOneState());

    // emit(ServicesGuestLoading());
    // emit(await _baseRepo.getOneOnOneTherapistsList());
  }

  _onGroupTherapySelected(GroupTherapyTabEvt event, emit) async {
    emit(ServicesGuestGroupTherapyState());
  }

  _onWorkshopsSelected(WorkshopsTabEvt event, emit) async {
    emit(ServicesGuestWorkshopsState());
  }

  _onProgramsSelected(ProgramsTabEvt event, emit) {
    emit(ServicesGuestProgramsState());

  }
  _onCouplesTherapySelected(CouplesTherapyTabEvt event, emit) {
    emit(ServicesGuestCouplesTherapyState());
  }
  _onAssessmentAndTestingSelected(AssessmentAndTestingTabEvt event, emit) async {
    emit(ServicesGuestAssessmentAndTestingState());
  }

  _onGetStartedSelected(GetStartedClickedEvt event, emit) async {
    toast('Get started pressed');
  }

  _onShowMoreGroupTherapySelected(
      ShowMoreGroupTherapyClickedEvt event, emit) async {
    toast('Show more pressed');
  }

  _onShowMoreWorkshopsSelected(ShowMoreWorkshopsClickedEvt event, emit) async {
    toast('Show more pressed');
  }


}
