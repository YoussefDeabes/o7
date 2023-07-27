import 'dart:async';
import 'dart:developer';

import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/models/booking/therapists_booked_before/therapists_booked_before_wrapper.dart';
import 'package:o7therapy/ui/screens/booking/bloc/therapists_booked_before_bloc/therapists_booked_before_bloc.dart';
import 'package:o7therapy/ui/screens/booking/models/therapist_data.dart';
import 'package:o7therapy/api/therapist_list_api_manager.dart';

abstract class BaseTherapistsBookedBeforeRepo {
  const BaseTherapistsBookedBeforeRepo();

  /// get therapist list
  Future<TherapistsBookedBeforeState> getTherapists({required int pageNumber});
}

class TherapistsBookedBeforeRepo extends BaseTherapistsBookedBeforeRepo {
  const TherapistsBookedBeforeRepo();

  @override
  Future<TherapistsBookedBeforeState> getTherapists({
    required int pageNumber,
  }) async {
    late TherapistsBookedBeforeState state;
    try {
      await TherapistListApiManager.therapistBookedBeforeApi(
        (TherapistsBookedBeforeWrapper therapistListWrapper) {
          List<TherapistData>? therapists = therapistListWrapper.data != null
              ? therapistListWrapper.data!
                  .map((datum) =>
                      TherapistData.fromBackEndBookedBeforeListData(datum))
                  .toList()
              : null;

          log("Booked with before therapists?.length:: ${therapists?.length}");
          if (therapists != null && therapists.isNotEmpty) {
            state = LoadedTherapistsBookedBeforeState(
              therapists: therapists,
              hasMore: false,
              pageNumber: pageNumber,
            );
          } else {
            state = LoadedTherapistsBookedBeforeState(
              therapists: const [],
              hasMore: false,
              pageNumber: pageNumber,
            );
          }
        },
        (NetworkExceptions details) {
          state = ExceptionTherapistsBookedBeforeState(
              details.errorMsg ?? "Oops... Something went wrong!");
        },
      );
    } catch (error) {
      state = const ExceptionTherapistsBookedBeforeState(
          "Oops... Something went wrong!");
    }
    return state;
  }
}
