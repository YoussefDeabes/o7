part of 'send_verification_code_bloc.dart';

class VerificationCodeEvent extends Equatable {
  const VerificationCodeEvent();

  @override
  List<Object> get props => [];
}

class SendVerificationCodeEvent extends VerificationCodeEvent {
  final int cardNumber;
  const SendVerificationCodeEvent(this.cardNumber);

  @override
  List<Object> get props => [cardNumber];
}
