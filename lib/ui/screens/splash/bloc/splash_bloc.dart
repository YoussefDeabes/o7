import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:o7therapy/api/models/enforce_update/EnforceUpdate.dart';
import 'package:o7therapy/ui/screens/splash/bloc/splash_repo.dart';

part 'splash_event.dart';

part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final BaseSplashRepo _baseRepo;

  SplashBloc(this._baseRepo) : super(SplashInitial()) {
    on<CheckEnforceUpdate>(_onCheckEnforceUpdate);
  }

  _onCheckEnforceUpdate(CheckEnforceUpdate event, emit) async {
    emit(await _baseRepo.checkEnforceUpdate(event.version));
  }
}
