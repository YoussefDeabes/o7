import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/models/guest_therapist_list/GuestTherapistList.dart';
import 'package:o7therapy/api/therapist_list_api_manager.dart';
import 'package:o7therapy/ui/screens/booking/models/therapist_data.dart';
import 'package:o7therapy/ui/screens/booking_guest/bloc/services_guest_bloc.dart';
import 'package:o7therapy/api/models/guest_therapist_list/List.dart';

abstract class BaseGuestServicesRepo {
  Future<ServicesGuestState> getOneOnOneTherapistsList();
}

class GuestServicesRepo extends BaseGuestServicesRepo {
  @override
  Future<ServicesGuestState> getOneOnOneTherapistsList() async {
    ServicesGuestState? servicesGuestState;
    NetworkExceptions? detailsModel;
    List<TherapistsList>? therapistsList;
    try {
      await TherapistListApiManager.therapistListGuestApi(
          (GuestTherapistList guestTherapistList) {
        therapistsList = guestTherapistList.data?.list;
        List<TherapistData> therapists = therapistsList!
            .map((element) =>
                TherapistData.fromBackEndTherapistListGuest(element))
            .toList();
        servicesGuestState =
            ServicesGuestOneOnOneState(therapistsList: therapists);
      }, (NetworkExceptions details) {
        servicesGuestState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      servicesGuestState =
          ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return servicesGuestState!;
  }
}
