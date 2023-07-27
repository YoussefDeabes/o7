part of 'sessions_credit_bloc.dart';

@immutable
abstract class SessionsCreditEvent {
  const SessionsCreditEvent();
}

class SessionsWalletLoading extends SessionsCreditEvent {}

class SessionsWalletFail extends SessionsCreditEvent {}

class GetTherapistBio extends SessionsCreditEvent {
  final String therapistId;
  const GetTherapistBio(this.therapistId);
}
