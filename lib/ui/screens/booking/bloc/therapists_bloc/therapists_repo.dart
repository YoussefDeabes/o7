import 'dart:async';
import 'dart:developer';

import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/ui/screens/booking/models/therapist_data.dart';
import 'package:o7therapy/api/models/booking/therapist_list/therapist_list_wrapper.dart';
import 'package:o7therapy/api/therapist_list_api_manager.dart';
import 'package:o7therapy/ui/screens/booking/bloc/therapists_bloc/therapists_bloc.dart';

abstract class BaseTherapistsRepo {
  const BaseTherapistsRepo();

  /// get therapist list
  Future<TherapistsState> getTherapists({
    required String attributeName,
    required String direction,
    required bool isAttributesUpdated,
    required Map<String, dynamic> queryParameters,
  });
}

class TherapistsRepo extends BaseTherapistsRepo {
  static int _pageNumber = 1;
  static bool _hasMore = false;

  const TherapistsRepo();

  @override
  Future<TherapistsState> getTherapists({
    required String attributeName,
    required String direction,
    required bool isAttributesUpdated,
    required Map<String, dynamic> queryParameters,
  }) async {
    //
    if (isAttributesUpdated) {
      _pageNumber = 1;
      _hasMore = false;
    }
    List<TherapistData>? therapists;
    late TherapistsState state;

    try {
      await TherapistListApiManager.therapistListApi(
        attributeName: attributeName,
        pageNumber: _pageNumber,
        direction: direction,
        filterParameters: queryParameters,
        (TherapistListWrapper therapistListWrapper) {
          therapists = therapistListWrapper.data?.list!
              .map((element) => TherapistData.fromBackEndListElement(element))
              .toList();
          _hasMore = therapistListWrapper.data!.hasMore!;

          log("${therapistListWrapper.data!.totalCount}");
          state = LoadedTherapistsState(
            isListUpdated: isAttributesUpdated,
            therapists: therapists!,
            hasMore: _hasMore,
          );
        },
        (NetworkExceptions details) {
          state = ExceptionTherapistsState(
              details.errorMsg ?? "Oops... Something went wrong!");
        },
      );
      if (_hasMore) {
        log("current page number: $_pageNumber");
        _pageNumber++;
      }
    } catch (error) {
      state = const ExceptionTherapistsState("Oops... Something went wrong!");
    }
    return state;
  }
}
