part of 'sessions_credit_bloc.dart';

@immutable
abstract class SessionsCreditState {
  const SessionsCreditState();
}

class SessionsCreditInitial extends SessionsCreditState {}

class SessionsWalletLoadingState extends SessionsCreditState {}

class SessionsCreditSuccess extends SessionsCreditState {
  final HasWalletSessions sessionsWalletList;

  const SessionsCreditSuccess(this.sessionsWalletList);
}

class SessionsCreditFail extends SessionsCreditState {
  const SessionsCreditFail();
}

class NetworkError extends SessionsCreditState {
  final String message;

  const NetworkError(this.message);
}

class ErrorState extends SessionsCreditState {
  final String message;

  const ErrorState(this.message);
}

class BioState extends SessionsCreditState {
  final TherapistBio bio;
  const BioState({required this.bio});
}
