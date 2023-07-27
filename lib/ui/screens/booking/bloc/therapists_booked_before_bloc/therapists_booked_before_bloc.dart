import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/ui/screens/booking/bloc/therapists_booked_before_bloc/therapists_booked_before_repo.dart';
import 'package:o7therapy/ui/screens/booking/models/therapist_data.dart';

part 'therapists_booked_before_event.dart';
part 'therapists_booked_before_state.dart';

class TherapistsBookedBeforeBloc
    extends Bloc<TherapistsBookedBeforeEvent, TherapistsBookedBeforeState> {
  final BaseTherapistsBookedBeforeRepo _repo;
  TherapistsBookedBeforeBloc(this._repo)
      : super(const TherapistsBookedBeforeInitial()) {
    on<GetTherapistsBookedBeforeEvent>(_onGetTherapistsBookedBeforeEvent);
    on<ResetTherapistsBookedBeforeEvent>(_onResetTherapistsBookedBeforeEvent);
  }

  static TherapistsBookedBeforeBloc bloc(BuildContext context) =>
      context.read<TherapistsBookedBeforeBloc>();

  static TherapistsBookedBeforeState lastState =
      const TherapistsBookedBeforeInitial();

  _onGetTherapistsBookedBeforeEvent(
    GetTherapistsBookedBeforeEvent event,
    emit,
  ) async {
    TherapistsBookedBeforeState state =
        await _repo.getTherapists(pageNumber: 1);

    //! the coming code was used if there was a pagination
    // if (state is LoadedTherapistsBookedBeforeState) {
    //   bool hasMore = state.hasMore;
    //   List<TherapistData> therapists = state.therapists;
    //   int comingPageNumber = state.pageNumber + 1;
    //   while (hasMore) {
    //     TherapistsBookedBeforeState newState =
    //         await _repo.getTherapists(pageNumber: comingPageNumber);
    //     if (newState is LoadedTherapistsBookedBeforeState) {
    //       hasMore = newState.hasMore;
    //       comingPageNumber = newState.pageNumber + 1;
    //       therapists.addAll(newState.therapists);
    //       state = LoadedTherapistsBookedBeforeState(
    //         pageNumber: comingPageNumber,
    //         hasMore: hasMore,
    //         therapists: therapists,
    //       );
    //     } else {
    //       state = const EmptyTherapistsBookedBeforeState();
    //       break;
    //     }
    //   }
    //   if (therapists.isNotEmpty) {
    //     emit(state);
    //   } else {
    //     emit(const EmptyTherapistsBookedBeforeState());
    //   }
    // } else {
    //   emit(const EmptyTherapistsBookedBeforeState());
    // }
    emit(state);
    lastState = state;
  }

  _onResetTherapistsBookedBeforeEvent(
    ResetTherapistsBookedBeforeEvent event,
    emit,
  ) async {
    emit(const TherapistsBookedBeforeInitial());
  }
}
