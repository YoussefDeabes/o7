import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/api/api_manager.dart';
import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/models/available_slots/AvailableSlotsWrapper.dart';

part 'therapist_available_slots_state.dart';

class TherapistAvailableSlotsCubit extends Cubit<TherapistAvailableSlotsState> {
  TherapistAvailableSlotsCubit()
      : super(
          const LoadingAvailableSlotsState(),
        );

  getTherapistAvailableSlots(String therapistId) async {
    emit(const LoadingAvailableSlotsState());
    emit(await _getTherapistAvailableSlots(therapistId));
  }

  static TherapistAvailableSlotsCubit bloc(BuildContext context) =>
      context.read<TherapistAvailableSlotsCubit>();

  Future<TherapistAvailableSlotsState> _getTherapistAvailableSlots(
    String therapistId,
  ) async {
    TherapistAvailableSlotsState? state;
    try {
      await ApiManager.getAvailableSlots(therapistId,
          (AvailableSlotsWrapper availableSlots) {
        state =
            TherapistAvailableSlotsDataState(availableSlots: availableSlots);
      }, (NetworkExceptions details) {
        state = ErrorAvailableSlotsState(details.errorMsg!);
      });
    } catch (error) {
      state = const ErrorAvailableSlotsState("");
    }
    return state!;
  }
}
