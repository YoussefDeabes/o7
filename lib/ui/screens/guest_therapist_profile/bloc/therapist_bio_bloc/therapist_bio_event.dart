part of 'therapist_bio_bloc.dart';

class GetTherapistBioEvent extends Equatable {
  final String therapistId;
  const GetTherapistBioEvent(this.therapistId);

  @override
  List<Object> get props => [therapistId];
}
