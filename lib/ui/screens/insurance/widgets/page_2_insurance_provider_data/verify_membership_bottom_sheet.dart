import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/res/const_values.dart';
import 'package:o7therapy/ui/screens/home/home_main_logged_in/home_main_logged_in/home_main_logged_in_screen.dart';
import 'package:o7therapy/ui/screens/insurance/bloc/insurance_status_bloc/insurance_status_bloc.dart';
import 'package:o7therapy/ui/screens/insurance/bloc/phone_masked_number_bloc/phone_masked_number_bloc.dart';
import 'package:o7therapy/ui/screens/insurance/bloc/send_verification_code_bloc/send_verification_code_bloc.dart';
import 'package:o7therapy/ui/screens/insurance/screen/verified_insurance_screen.dart';
import 'package:o7therapy/ui/screens/insurance/widgets/shared_widgets/shared_widgets.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyMembershipBottomSheet extends BaseStatefulWidget {
  final int membershipNumber;
  final String providerName;
  const VerifyMembershipBottomSheet({
    required this.membershipNumber,
    required this.providerName,
    super.backGroundColor = Colors.transparent,
    super.key,
  });

  @override
  BaseState<VerifyMembershipBottomSheet> baseCreateState() {
    return _VerifyMembershipBottomSheetState();
  }
}

class _VerifyMembershipBottomSheetState
    extends BaseState<VerifyMembershipBottomSheet> {
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

  late Timer _countdownTimer;
  static const Duration _totalDuration =
      Duration(seconds: ConstValues.timerDuration);
  Duration _counterCurrentDuration = _totalDuration;
  bool _isAllPinsAreSet = false;
  static const int pinCodeTextFieldLength = 4;

  TextEditingController otpTextEditingController = TextEditingController();

  @override
  void initState() {
    /// used to get the masked phone number from the back end
    PhoneMaskedNumberBloc.bloc(context)
        .add(GetPhoneMaskedNumberEvent(widget.membershipNumber.toString()));
    // start timer when the bottom sheet open
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    _stopTimer();
    super.dispose();
  }

  @override
  Widget baseBuild(BuildContext context) {
    return BlocListener<InsuranceStatusBloc, InsuranceStatusState>(
        listener: (context, state) {
          if (state is LoadingInsuranceStatus) {
            showLoading();
          } else {
            hideLoading();
          }
          if (state is SuccessVerifiedInsuranceStatus) {
            Navigator.pop(context);
            Navigator.of(context).pushReplacementNamed(
              VerifiedInsuranceScreen.routeName,
            );
            showToast("Insurance Updated");
          }
        },
        child: FractionallySizedBox(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(
                start: 24, end: 24, bottom: 24),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 0.05 * height),
                        _getBottomSheetTitle(
                            translate(LangKeys.verifyYourMembership)),
                        SizedBox(height: 0.02 * height),
                        _getEnterTheFourDigitsCodeText(),
                        _pinCodeFields(),
                        _getCountdown(),
                        _getDidNotReceiveCodeText(),
                      ],
                    ),
                  )),
                  SizedBox(height: 0.01 * height),
                  _getVerifyButton(),
                  SizedBox(height: 0.02 * height),
                ]),
          ),
        ));
  }

  /// get centered bottom sheet title
  Widget _getBottomSheetTitle(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          color: ConstColors.app,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  /// Enter enterTheFourDigitCode Centered text
  Widget _getEnterTheFourDigitsCodeText() {
    return BlocBuilder<PhoneMaskedNumberBloc, PhoneMaskedNumberState>(
      builder: (context, state) {
        final String phoneNumber = state.maskedPhoneNumber;
        return Center(
          child: Text(
            "${translate(LangKeys.enterTheFourDigitCode)} ${widget.providerName} ${translate(LangKeys.sentToYourPhoneNumber)} $phoneNumber",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: ConstColors.text,
            ),
          ),
        );
      },
    );
  }

  /// Pin code field
  Widget _pinCodeFields() {
    return Padding(
      padding: EdgeInsets.only(left: 45, right: 45, top: height / 30),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: PinCodeTextField(
          appContext: context,
          controller: otpTextEditingController,
          length: pinCodeTextFieldLength,
          cursorColor: ConstColors.appGrey,
          textStyle: const TextStyle(color: ConstColors.text),
          obscureText: false,
          pinTheme: PinTheme(
            borderRadius: BorderRadius.circular(12),
            activeColor: ConstColors.textGrey,
            disabledColor: ConstColors.textGrey,
            borderWidth: 1,
            fieldWidth: 48,
            fieldHeight: 56,
            selectedColor: ConstColors.textGrey,
            errorBorderColor: ConstColors.error,
            activeFillColor: ConstColors.textGrey,
            inactiveColor: ConstColors.textGrey,
            shape: PinCodeFieldShape.box,
          ),
          animationType: AnimationType.fade,
          animationDuration: const Duration(milliseconds: 150),
          errorAnimationController: errorController,
          keyboardType: TextInputType.number,
          onCompleted: (value) => setState(() => _isAllPinsAreSet = true),
          onChanged: (value) {
            if (value.length != pinCodeTextFieldLength) {
              setState(() => _isAllPinsAreSet = false);
            }
          },
        ),
      ),
    );
  }

  /// Countdown widget
  Widget _getCountdown() {
    return Text(
      "$minutes:$seconds",
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: _countdownTimer.isActive
            ? ConstColors.accentColor
            : ConstColors.appGrey,
      ),
    );
  }

  //Didn't receive the code field
  Widget _getDidNotReceiveCodeText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          translate(LangKeys.doNotReceivedCode),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: ConstColors.text,
          ),
        ),
        _resendButton(),
      ],
    );
  }

// Resend button
  Widget _resendButton() {
    // if the Timer isActive >>then  make it disabled
    // and change the color
    return TextButton(
      onPressed: _countdownTimer.isActive
          ? null
          : () async {
              showLoading();
              SendVerificationCodeState state =
                  await SendVerificationCodeBloc.bloc(context)
                      .reSendVerificationCodeToVerifyInsurance(
                widget.membershipNumber,
              );
              hideLoading();
              if (state is SentCodeVerification) {
                otpTextEditingController.clear();
                setState(() => restartTimer());
              } else if (state is ExceptionSendCodeVerification) {
                showToast(state.msg);
              }
            },
      child: Text(
        translate(LangKeys.resend),
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: _countdownTimer.isActive
              ? ConstColors.textGrey
              : ConstColors.secondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// get Verify button
  Widget _getVerifyButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: InsurancePageButton(
        fontColor:
            _isAllPinsAreSet ? ConstColors.appWhite : ConstColors.textDisabled,
        borderSideColor: Colors.transparent,
        buttonLabel: translate(LangKeys.verify),
        onPressed: !_isAllPinsAreSet
            ? null
            : () {
                InsuranceStatusBloc.bloc(context).add(
                  ValidateOtpInsuranceStatusEvent(
                    cardNumber: widget.membershipNumber.toString(),
                    otp: otpTextEditingController.text,
                  ),
                );
              },
        width: width * 0.5,
      ),
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Helper methods ///////////////////////
///////////////////////////////////////////////////////////

  String strDigits(int n) => n.toString().padLeft(2, '0');
  String get minutes =>
      strDigits(_counterCurrentDuration.inMinutes.remainder(60));
  String get seconds =>
      strDigits(_counterCurrentDuration.inSeconds.remainder(60));

  /// init timer and start to count down
  void _startTimer() {
    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setCountDown(),
    );
  }

  // To Stop the timer from counting down
  void _stopTimer() {
    _countdownTimer.cancel();
  }

  /// Stop the timer and reset the current duration to begin duration
  void restartTimer() {
    _stopTimer();
    setState(() => _counterCurrentDuration = _totalDuration);
    _startTimer();
  }

  /// what will happen each second
  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = _counterCurrentDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        _countdownTimer.cancel();
      } else {
        _counterCurrentDuration = Duration(seconds: seconds);
      }
    });
  }
}
