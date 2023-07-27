part of 'home_screen_therapists_bloc.dart';

abstract class HomeScreenTherapistsState extends Equatable {
  const HomeScreenTherapistsState();
  @override
  List<Object?> get props => [];
}

class HomeScreenTherapistsInitial extends HomeScreenTherapistsState {
  @override
  List<Object> get props => [];
}

class LoadingHomeScreenTherapistsState extends HomeScreenTherapistsState {
  const LoadingHomeScreenTherapistsState();
}

class LoadedHomeScreenTherapistsState extends HomeScreenTherapistsState {
  final List<TherapistData> therapists;
  const LoadedHomeScreenTherapistsState({required this.therapists});
}

class ExceptionHomeScreenTherapistsState extends HomeScreenTherapistsState {
  final String exception;

  const ExceptionHomeScreenTherapistsState(this.exception);
}
