part of 'services_guest_bloc.dart';

@immutable
abstract class ServicesGuestEvent {}

class OneOnSessionsTabEvt extends ServicesGuestEvent {}

class GroupTherapyTabEvt extends ServicesGuestEvent {}

class WorkshopsTabEvt extends ServicesGuestEvent {}

class AssessmentAndTestingTabEvt extends ServicesGuestEvent {}

class ProgramsTabEvt extends ServicesGuestEvent {}

class CouplesTherapyTabEvt extends ServicesGuestEvent {}

class GetStartedClickedEvt extends ServicesGuestEvent {}

class ShowMoreGroupTherapyClickedEvt extends ServicesGuestEvent {}

class ShowMoreWorkshopsClickedEvt extends ServicesGuestEvent {}
