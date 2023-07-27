import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../booking/models/therapist_data.dart';
import 'home_screen_therapists_repo.dart';

part 'home_screen_therapists_event.dart';
part 'home_screen_therapists_state.dart';

class HomeScreenTherapistsBloc
    extends Bloc<HomeScreenTherapistsEvent, HomeScreenTherapistsState> {
  final BaseHomeScreenTherapistsRepo _baseHomeScreenTherapistsRepo;

  HomeScreenTherapistsBloc({
    required BaseHomeScreenTherapistsRepo baseHomeScreenTherapistsRepo,
  })  : _baseHomeScreenTherapistsRepo = baseHomeScreenTherapistsRepo,
        super(HomeScreenTherapistsInitial()) {
    on<GetThreeTherapistsEvent>(_onGetThreeTherapistsEvent);
  }
  static HomeScreenTherapistsBloc bloc(BuildContext context) =>
      context.read<HomeScreenTherapistsBloc>();

  _onGetThreeTherapistsEvent(GetThreeTherapistsEvent event, emit) async {
    emit(const LoadingHomeScreenTherapistsState());
    emit(await _baseHomeScreenTherapistsRepo.getTherapists());
  }
}
