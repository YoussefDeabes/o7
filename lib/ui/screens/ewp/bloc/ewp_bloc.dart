import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/ui/screens/ewp/bloc/ewp_repo.dart';
import 'package:o7therapy/ui/screens/ewp/models/ewp_view_model.dart';

part 'ewp_event.dart';
part 'ewp_state.dart';

class EwpBloc extends Bloc<GetEwpEvent, EwpState> {
  final BaseEwpRepository _repo;
  EwpBloc(this._repo) : super(EwpInitial()) {
    on<GetEwpEvent>(_onGetEwpEvent);
  }

  static EwpBloc getBloc(BuildContext context) => context.read<EwpBloc>();
  _onGetEwpEvent(event, emit) async {
    emit(const LoadingEwpState());
    EwpState? checkUserIsCorporateState = await _repo.checkUserIsCorporate();
    if (checkUserIsCorporateState == null) {
      emit(await _repo.getRemainingCapNoForEwp());
    } else {
      emit(checkUserIsCorporateState);
    }
  }
}
