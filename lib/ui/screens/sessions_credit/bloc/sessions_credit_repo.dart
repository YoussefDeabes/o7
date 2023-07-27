import 'dart:async';

import 'package:o7therapy/api/api_manager.dart';
import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/models/has_wallet_sessions/HasWalletSessions.dart';
import 'package:o7therapy/api/models/therapist_bio/TherapistBio.dart';
import 'package:o7therapy/ui/screens/sessions_credit/bloc/sessions_credit_bloc.dart';

abstract class BaseSessionsCreditRepo {
  const BaseSessionsCreditRepo();

  Future<SessionsCreditState> walletSessions();
  Future<SessionsCreditState> getTherapistBio(String id);
}

class SessionsCreditRepo extends BaseSessionsCreditRepo {
  const SessionsCreditRepo();

  @override
  Future<SessionsCreditState> walletSessions() async {
    SessionsCreditState? sessionsWalletState;
    NetworkExceptions? detailsModel;
    try {
      await ApiManager.sessionsWallet((HasWalletSessions sessionsList) async {
        if (sessionsList.data!.list!.isEmpty ||
            sessionsList.data!.list == null) {
          sessionsWalletState = const SessionsCreditFail();
        } else {
          sessionsWalletState = SessionsCreditSuccess(sessionsList);
        }
      }, (NetworkExceptions details) {
        detailsModel = details;
        sessionsWalletState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      sessionsWalletState =
          ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return sessionsWalletState!;
  }

  @override
  Future<SessionsCreditState> getTherapistBio(String id) async {
    SessionsCreditState? therapistProfileState;
    NetworkExceptions? detailsModel;
    try {
      await ApiManager.therapistBio(id, (TherapistBio bio) {
        therapistProfileState = BioState(bio: bio);
      }, (NetworkExceptions details) {
        detailsModel = details;
        therapistProfileState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      therapistProfileState =
          ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return therapistProfileState!;
  }
}
