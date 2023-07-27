import 'dart:developer';

import '../../../../api/errors/network_exceptions.dart';
import '../../../../api/models/booking/therapist_list/therapist_list_wrapper.dart';
import '../../../../api/therapist_list_api_manager.dart';
import '../../booking/models/therapist_data.dart';
import 'home_screen_therapists_bloc.dart';

abstract class BaseHomeScreenTherapistsRepo {
  const BaseHomeScreenTherapistsRepo();

  /// get therapist list
  Future<HomeScreenTherapistsState> getTherapists();
}

class HomeScreenTherapistsRepo extends BaseHomeScreenTherapistsRepo {
  const HomeScreenTherapistsRepo();

  @override
  Future<HomeScreenTherapistsState> getTherapists() async {
    late HomeScreenTherapistsState state;
    try {
      await TherapistListApiManager.therapistListApi(
        pageSize: 3,
        attributeName: "Availability",
        direction: "Asc",
        filterParameters: {},
        (TherapistListWrapper therapistListWrapper) {
          List<TherapistData>? therapists = therapistListWrapper.data?.list!
              .map((element) => TherapistData.fromBackEndListElement(element))
              .toList();

          log("Home Screen Therapists: ${therapists?.length}");
          if (therapists != null) {
            state = LoadedHomeScreenTherapistsState(
              therapists: therapists,
            );
          } else {
            state = const LoadedHomeScreenTherapistsState(
              therapists: [],
            );
          }
        },
        (NetworkExceptions details) {
          state = ExceptionHomeScreenTherapistsState(
              details.errorMsg ?? "Oops... Something went wrong!");
        },
      );
    } catch (error) {
      state = const ExceptionHomeScreenTherapistsState(
          "Oops... Something went wrong!");
    }
    return state;
  }
}
