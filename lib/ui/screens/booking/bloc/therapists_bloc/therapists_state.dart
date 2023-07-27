part of 'therapists_bloc.dart';

abstract class TherapistsState extends Equatable {
  const TherapistsState();

  @override
  List<Object> get props => [];
}

class LoadingTherapistsState extends TherapistsState {
  const LoadingTherapistsState();
}

class LoadedTherapistsState extends TherapistsState {
  final List<TherapistData> therapists;
  final bool hasMore;
  final bool isListUpdated;

  const LoadedTherapistsState({
    required this.therapists,
    required this.hasMore,
    this.isListUpdated = false,
  });

  @override
  List<Object> get props => [therapists, isListUpdated];

  LoadedTherapistsState copyWith({
    List<TherapistData>? therapists,
    bool? hasMore,
    bool? isListUpdated,
  }) {
    return LoadedTherapistsState(
      therapists: therapists ?? this.therapists,
      hasMore: hasMore ?? this.hasMore,
      isListUpdated: isListUpdated ?? this.isListUpdated,
    );
  }
}

class ExceptionTherapistsState extends TherapistsState {
  final String exception;
  const ExceptionTherapistsState(this.exception);
}
