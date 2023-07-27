part of 'therapist_bio_bloc.dart';

abstract class TherapistBioState extends Equatable {
  const TherapistBioState();

  @override
  List<Object> get props => [];
}

class TherapistBioLoadingState extends TherapistBioState {
  const TherapistBioLoadingState();
}

class TherapistBioErrorState extends TherapistBioState {
  final String? msg;
  const TherapistBioErrorState(this.msg);
}

class TherapistBioDataState extends TherapistBioState {
  final TherapistBio bio;
  const TherapistBioDataState({required this.bio});
}
