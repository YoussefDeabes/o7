part of 'forget_password_bloc.dart';

abstract class ForgetPasswordEvent extends Equatable {
  const ForgetPasswordEvent();

  @override
  List<Object> get props => [];
}

class SendEmailForgetPasswordEvent extends ForgetPasswordEvent {
  final String email;
  const SendEmailForgetPasswordEvent({required this.email});

  @override
  List<Object> get props => [email];
}

class ProceedForgetPasswordEvent extends ForgetPasswordEvent {
  final String code;
  const ProceedForgetPasswordEvent({required this.code});

  @override
  List<Object> get props => [code];
}

class SubmitNewPasswordEvent extends ForgetPasswordEvent {
  final String newPassword;
  const SubmitNewPasswordEvent({required this.newPassword});

  @override
  List<Object> get props => [newPassword];
}

class ResendCodeForgetPasswordEvent extends ForgetPasswordEvent {
  const ResendCodeForgetPasswordEvent();

  @override
  List<Object> get props => [];
}
