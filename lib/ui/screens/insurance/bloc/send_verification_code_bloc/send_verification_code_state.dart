part of 'send_verification_code_bloc.dart';

abstract class SendVerificationCodeState extends Equatable {
  const SendVerificationCodeState();

  @override
  List<Object> get props => [];
}

class SendVerificationCodeInitial extends SendVerificationCodeState {}

class SentCodeVerification extends SendVerificationCodeState {
  const SentCodeVerification();
}

class LoadingSendingCodeVerification extends SendVerificationCodeState {
  const LoadingSendingCodeVerification();
}

class NotSentCodeVerification extends SendVerificationCodeState {
  const NotSentCodeVerification();
}

class ExceptionSendCodeVerification extends SendVerificationCodeState {
  final String msg;
  const ExceptionSendCodeVerification({required this.msg});
}
