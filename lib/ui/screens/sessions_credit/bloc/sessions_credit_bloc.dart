import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:o7therapy/api/models/has_wallet_sessions/HasWalletSessions.dart';
import 'package:o7therapy/api/models/therapist_bio/TherapistBio.dart';
import 'package:o7therapy/ui/screens/sessions_credit/bloc/sessions_credit_repo.dart';

part 'sessions_credit_event.dart';

part 'sessions_credit_state.dart';

class SessionsCreditBloc
    extends Bloc<SessionsCreditEvent, SessionsCreditState> {
  final BaseSessionsCreditRepo _baseRepo;

  SessionsCreditBloc(this._baseRepo) : super(SessionsCreditInitial()) {
    on<SessionsWalletLoading>(_onSessionCreditLoading);
  }

  _onSessionCreditLoading(SessionsWalletLoading event, emit) async {
    emit(SessionsWalletLoadingState());
    emit(await _baseRepo.walletSessions());
  }

  Future<SessionsCreditState> getTherapistBio(String therapistId) async {
    return await _baseRepo.getTherapistBio(therapistId);
  }
}
