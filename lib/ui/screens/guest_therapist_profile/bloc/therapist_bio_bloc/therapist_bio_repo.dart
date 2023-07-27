part of 'therapist_bio_bloc.dart';

abstract class BaseTherapistBioRepo {
  const BaseTherapistBioRepo();

  Future<TherapistBioState> getTherapistBio(String id);
}

class TherapistBioRepo extends BaseTherapistBioRepo {
  const TherapistBioRepo();

  @override
  Future<TherapistBioState> getTherapistBio(String id) async {
    TherapistBioState? therapistBioState;
    NetworkExceptions? detailsModel;
    try {
      await ApiManager.therapistBio(id, (TherapistBio bio) {
        therapistBioState = TherapistBioDataState(bio: bio);
      }, (NetworkExceptions details) {
        detailsModel = details;
        therapistBioState = TherapistBioErrorState(details.errorMsg!);
      });
    } catch (error) {
      therapistBioState =
          TherapistBioErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return therapistBioState!;
  }
}
