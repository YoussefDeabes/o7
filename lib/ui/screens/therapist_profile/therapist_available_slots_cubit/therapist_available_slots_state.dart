part of 'therapist_available_slots_cubit.dart';

abstract class TherapistAvailableSlotsState extends Equatable {
  const TherapistAvailableSlotsState();

  @override
  List<Object> get props => [];
}

class LoadingAvailableSlotsState extends TherapistAvailableSlotsState {
  const LoadingAvailableSlotsState();
}

class ErrorAvailableSlotsState extends TherapistAvailableSlotsState {
  final String? msg;
  const ErrorAvailableSlotsState(this.msg);
}

class TherapistAvailableSlotsDataState extends TherapistAvailableSlotsState {
  final AvailableSlotsWrapper availableSlots;
  const TherapistAvailableSlotsDataState({required this.availableSlots});
}
