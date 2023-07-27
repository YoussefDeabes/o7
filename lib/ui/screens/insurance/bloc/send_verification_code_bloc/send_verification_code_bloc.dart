import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/insurance_api_manager.dart';
import 'package:o7therapy/api/models/insurance/resend_verification_code_for_insurance/resend_verification_code_for_insurance.dart';

part 'send_verification_code_state.dart';
part 'send_verification_code_event.dart';

class SendVerificationCodeBloc
    extends Bloc<VerificationCodeEvent, SendVerificationCodeState> {
  SendVerificationCodeBloc._internal() : super(SendVerificationCodeInitial()) {
    on<SendVerificationCodeEvent>(_onSendVerificationCodeToVerifyInsurance);
  }
  static final SendVerificationCodeBloc _instance =
      SendVerificationCodeBloc._internal();

  factory SendVerificationCodeBloc() {
    return _instance;
  }

  static SendVerificationCodeBloc bloc(BuildContext context) =>
      context.read<SendVerificationCodeBloc>();

  void _onSendVerificationCodeToVerifyInsurance(event, emit) async {
    emit(const LoadingSendingCodeVerification());
    SendVerificationCodeState? state;

    try {
      await InsuranceApiManager.resendVerificationCode(
        cardNumber: event.cardNumber,
        success: (ResendVerificationCodeForInsuranceModel wrapper) {
          if (wrapper.data == null || wrapper.data == false) {
            state = const NotSentCodeVerification();
          } else {
            state = const SentCodeVerification();
          }
        },
        fail: (NetworkExceptions details) {
          state = ExceptionSendCodeVerification(msg: details.errorMsg ?? "");
        },
      );
    } catch (error) {
      state = const ExceptionSendCodeVerification(msg: "Unknown error");
    }
    emit(state!);
  }

  /// this method not used in the emit
  /// used while resend button pressed
  /// no emit in this method
  Future<SendVerificationCodeState> reSendVerificationCodeToVerifyInsurance(
    cardNumber,
  ) async {
    SendVerificationCodeState? state;
    try {
      await InsuranceApiManager.resendVerificationCode(
        cardNumber: cardNumber,
        success: (ResendVerificationCodeForInsuranceModel wrapper) {
          if (wrapper.data == null || wrapper.data == false) {
            state = const NotSentCodeVerification();
          } else {
            state = const SentCodeVerification();
          }
        },
        fail: (NetworkExceptions details) {
          state = ExceptionSendCodeVerification(msg: details.errorMsg ?? "");
        },
      );
    } catch (error) {
      state = const ExceptionSendCodeVerification(msg: "Unknown error");
    }
    return (state!);
  }
}
