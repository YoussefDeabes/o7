import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/ui/screens/auth/forget_password/bloc/forget_password_repo.dart';

part 'forget_password_event.dart';
part 'forget_password_state.dart';

class ForgetPasswordBloc
    extends Bloc<ForgetPasswordEvent, ForgetPasswordState> {
  final BaseForgetPasswordRepo _repo;
  ForgetPasswordBloc(this._repo) : super(const ForgetPasswordInitial()) {
    on<SendEmailForgetPasswordEvent>(_onSendEmailForgetPasswordEvent);
    on<ProceedForgetPasswordEvent>(_onProceedForgetPasswordEvent);
    on<SubmitNewPasswordEvent>(_onSubmitNewPasswordEvent);
    on<ResendCodeForgetPasswordEvent>(_onResendCodeForgetPasswordEvent);
  }

  static ForgetPasswordBloc bloc(BuildContext context) =>
      context.read<ForgetPasswordBloc>();

  _onSendEmailForgetPasswordEvent(
    SendEmailForgetPasswordEvent event,
    emit,
  ) async {
    emit(const LoadingForgetPasswordState());
    emit(await _repo.sendEmailNeedToChangePassword(email: event.email));
  }

  _onProceedForgetPasswordEvent(
    ProceedForgetPasswordEvent event,
    emit,
  ) async {
    emit(const LoadingForgetPasswordState());
    emit(await _repo.checkEnteredOtp(otp: event.code));
  }

  _onSubmitNewPasswordEvent(
    SubmitNewPasswordEvent event,
    emit,
  ) async {
    emit(const LoadingForgetPasswordState());
    emit(await _repo.verifyNewPassword(newPassword: event.newPassword));
  }

  _onResendCodeForgetPasswordEvent(
    ResendCodeForgetPasswordEvent event,
    emit,
  ) async {
    emit(const LoadingForgetPasswordState());
    emit(await _repo.resendOtp());
  }
}
