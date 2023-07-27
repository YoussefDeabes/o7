part of 'services_guest_bloc.dart';

@immutable
abstract class ServicesGuestState {
  const ServicesGuestState();
}

class ServicesGuestInitial extends ServicesGuestState {}

class ServicesGuestLoading extends ServicesGuestState {}

class ServicesGuestOneOnOneState extends ServicesGuestState {
  final List<TherapistData>? therapistsList;

  const ServicesGuestOneOnOneState({this.therapistsList});
}

 class ServicesGuestGroupTherapyState extends ServicesGuestState {
  const ServicesGuestGroupTherapyState();
 }

class ServicesGuestWorkshopsState extends ServicesGuestState {
  const ServicesGuestWorkshopsState();

}

class ServicesGuestProgramsState extends ServicesGuestState {
  const ServicesGuestProgramsState();

}

class ServicesGuestAssessmentAndTestingState extends ServicesGuestState {
  const ServicesGuestAssessmentAndTestingState();

}

class ServicesGuestCouplesTherapyState extends ServicesGuestState {
  const ServicesGuestCouplesTherapyState();

}

class GetStartedState extends ServicesGuestState {}

class ShowMoreGroupTherapyState extends ServicesGuestState {}

class ShowMoreWorkshopsState extends ServicesGuestState {}

class NetworkError extends ServicesGuestState {
  final String message;

  const NetworkError(this.message);
}

class ErrorState extends ServicesGuestState {
  final String message;

  const ErrorState(this.message);
}
