part of 'forget_password_bloc.dart';

abstract class ForgetPasswordState extends Equatable {
  const ForgetPasswordState();

  @override
  List<Object> get props => [];
}

class ForgetPasswordInitial extends ForgetPasswordState {
  const ForgetPasswordInitial();
}

class LoadingForgetPasswordState extends ForgetPasswordState {
  const LoadingForgetPasswordState();
}

class ExceptionForgetPasswordState extends ForgetPasswordState {
  final String msg;
  const ExceptionForgetPasswordState({
    required this.msg,
  });

  @override
  List<Object> get props => [msg];
}

class SuccessSendEmailState extends ForgetPasswordState {
  const SuccessSendEmailState();
}

class SuccessProceedState extends ForgetPasswordState {
  final String? userReferenceNumber;

  const SuccessProceedState({required this.userReferenceNumber});
}

class SuccessResendCodeState extends ForgetPasswordState {
  const SuccessResendCodeState();
}

class SuccessUpdatePasswordState extends ForgetPasswordState {
  const SuccessUpdatePasswordState();
}
