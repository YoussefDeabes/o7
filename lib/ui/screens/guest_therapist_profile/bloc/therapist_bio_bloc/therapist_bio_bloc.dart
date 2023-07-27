import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:o7therapy/api/api_manager.dart';
import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/models/therapist_bio/TherapistBio.dart';

part 'therapist_bio_event.dart';
part 'therapist_bio_repo.dart';
part 'therapist_bio_state.dart';

class TherapistBioBloc extends Bloc<GetTherapistBioEvent, TherapistBioState> {
  final TherapistBioRepo _repo;
  TherapistBioBloc(this._repo) : super(const TherapistBioLoadingState()) {
    on<GetTherapistBioEvent>(_onGetTherapistBioEvent);
  }

  static TherapistBioBloc bloc(BuildContext context) =>
      context.read<TherapistBioBloc>();

  FutureOr<void> _onGetTherapistBioEvent(
    GetTherapistBioEvent event,
    Emitter<TherapistBioState> emit,
  ) async {
    emit(const TherapistBioLoadingState());
    emit(await _repo.getTherapistBio(event.therapistId));
  }
}
