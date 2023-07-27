import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/forget_password_api_manager.dart';
import 'package:o7therapy/ui/screens/auth/forget_password/bloc/forget_password_bloc.dart';
import 'package:o7therapy/ui/screens/auth/forget_password/models/change_forget_password_data_model.dart';

abstract class BaseForgetPasswordRepo {
  const BaseForgetPasswordRepo();

  Future<ForgetPasswordState> sendEmailNeedToChangePassword({
    required String email,
  });

  Future<ForgetPasswordState> checkEnteredOtp({
    required String otp,
  });

  Future<ForgetPasswordState> verifyNewPassword({
    required String newPassword,
  });

  Future<ForgetPasswordState> resendOtp();
}

class ForgetPasswordRepo implements BaseForgetPasswordRepo {
  final ChangeForgetPasswordDataModel model;
  const ForgetPasswordRepo({required this.model});

  @override
  Future<ForgetPasswordState> sendEmailNeedToChangePassword({
    required String email,
  }) async {
    late ForgetPasswordState state;
    model.userEmail = email;
    try {
      await ForgetPasswordApiManager.sendForgotPasswordApi(
        email: email,
        success: () {
          state = const SuccessSendEmailState();
        },
        fail: (NetworkExceptions details) {
          state = ExceptionForgetPasswordState(
              msg: details.errorMsg ?? "Oops... Something went wrong!");
        },
      );
    } catch (error) {
      state = const ExceptionForgetPasswordState(
          msg: "Oops... Something went wrong!");
    }
    return state;
  }

  @override
  Future<ForgetPasswordState> checkEnteredOtp({
    required String otp,
  }) async {
    late ForgetPasswordState state;
    model.code = otp;
    try {
      await ForgetPasswordApiManager.forgotPasswordCodeVerificationApi(
        email: model.userEmail!,
        code: otp,
        success: (userReferenceNumber) {
          state =  SuccessProceedState(userReferenceNumber:userReferenceNumber);
        },
        fail: (NetworkExceptions details) {
          state = ExceptionForgetPasswordState(
              msg: details.errorMsg ?? "Oops... Something went wrong!");
        },
      );
    } catch (error) {
      state = const ExceptionForgetPasswordState(
          msg: "Oops... Something went wrong!");
    }
    return state;
  }

  @override
  Future<ForgetPasswordState> verifyNewPassword({
    required String newPassword,
  }) async {
    late ForgetPasswordState state;
    model.newPassword = newPassword;
    try {
      await ForgetPasswordApiManager.forgotPasswordVerificationApi(
        data: model.toQueryDataMap(),
        success: () {
          state = const SuccessUpdatePasswordState();
        },
        fail: (NetworkExceptions details) {
          state = ExceptionForgetPasswordState(
              msg: details.errorMsg ?? "Oops... Something went wrong!");
        },
      );
    } catch (error) {
      state = const ExceptionForgetPasswordState(
          msg: "Oops... Something went wrong!");
    }
    return state;
  }

  @override
  Future<ForgetPasswordState> resendOtp() async {
    ForgetPasswordState state =
        await sendEmailNeedToChangePassword(email: model.userEmail!);
    if (state is SuccessSendEmailState) {
      state = const SuccessResendCodeState();
    }
    return state;
  }
}
