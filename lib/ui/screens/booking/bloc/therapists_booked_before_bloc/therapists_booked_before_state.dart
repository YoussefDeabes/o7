part of 'therapists_booked_before_bloc.dart';

abstract class TherapistsBookedBeforeState extends Equatable {
  const TherapistsBookedBeforeState();

  @override
  List<Object> get props => [];
}

class TherapistsBookedBeforeInitial extends TherapistsBookedBeforeState {
  const TherapistsBookedBeforeInitial();
}

class ExceptionTherapistsBookedBeforeState extends TherapistsBookedBeforeState {
  final String msg;
  const ExceptionTherapistsBookedBeforeState(this.msg);

  @override
  List<Object> get props => [msg];
}

class LoadedTherapistsBookedBeforeState extends TherapistsBookedBeforeState {
  final int pageNumber;
  final bool hasMore;
  final List<TherapistData> therapists;
  const LoadedTherapistsBookedBeforeState({
    required this.pageNumber,
    required this.hasMore,
    required this.therapists,
  });

  @override
  List<Object> get props => [pageNumber, hasMore, therapists];
}
