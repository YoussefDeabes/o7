part of 'therapists_booked_before_bloc.dart';

abstract class TherapistsBookedBeforeEvent extends Equatable {
  const TherapistsBookedBeforeEvent();

  @override
  List<Object> get props => [];
}

class GetTherapistsBookedBeforeEvent extends TherapistsBookedBeforeEvent {
  const GetTherapistsBookedBeforeEvent();
}

class ResetTherapistsBookedBeforeEvent extends TherapistsBookedBeforeEvent {
  const ResetTherapistsBookedBeforeEvent();
}
