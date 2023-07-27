import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/res/const_values.dart';
import 'package:o7therapy/ui/screens/auth/forget_password/bloc/forget_password_bloc.dart';
import 'package:o7therapy/ui/screens/auth/forget_password/create_new_password_screen.dart';
import 'package:o7therapy/ui/screens/auth/forget_password/widgets/forget_password_screens_button.dart';
import 'package:o7therapy/ui/screens/auth/forget_password/widgets/reset_password_header_image.dart';
import 'package:o7therapy/ui/screens/auth/forget_password/widgets/reset_password_two_colored_header_text.dart';
import 'package:o7therapy/ui/screens/auth/widgets/did_not_receive_email_field_text.dart';
import 'package:o7therapy/ui/widgets/app_bar_more_screens/app_bar_more_screens.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyEmailForForgetPasswordScreen extends BaseScreenWidget {
  static const routeName = '/verify-email-for-forget-password-screen';

  const VerifyEmailForForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  BaseState<VerifyEmailForForgetPasswordScreen> screenCreateState() {
    return _VerifyEmailForForgetPasswordScreenState();
  }
}

class _VerifyEmailForForgetPasswordScreenState
    extends BaseState<VerifyEmailForForgetPasswordScreen> {
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

  late Timer _countdownTimer;
  bool _isAllPinsAreSet = false;
  static const int pinCodeTextFieldLength = 4;
  static const Duration _totalDuration =
      Duration(seconds: ConstValues.timerDuration);
  String? _email;
  Duration _counterCurrentDuration = _totalDuration;

  TextEditingController otpTextEditingController = TextEditingController();

  @override
  void initState() {
    // start timer when the bottom sheet open
    _startTimer();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _email ??= ModalRoute.of(context)!.settings.arguments as String;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    errorController.close();
    _stopTimer();
    super.dispose();
  }

  @override
  Widget baseBuild(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: BlocListener<ForgetPasswordBloc, ForgetPasswordState>(
          listener: (context, state) {
            if (state is LoadingForgetPasswordState) {
              showLoading();
            } else {
              hideLoading();
            }
            if (state is SuccessProceedState) {
              Navigator.of(context)
                  .pushNamed(CreateNewPasswordScreen.routeName,arguments: {"userReferenceNumber":state.userReferenceNumber});
            } else if (state is SuccessResendCodeState) {
              setState(() => restartTimer());
              otpTextEditingController.clear();
            }
          },
          child: Scaffold(
            appBar: const AppBarForMoreScreens(
              title: '',
              color: Colors.transparent,
            ),
            resizeToAvoidBottomInset: true,
            body: _getScreenContent(),
          ),
        ),
      ),
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////
  /// Get Screen content
  Widget _getScreenContent() {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(right: 24.0, left: 24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const ResetPasswordHeaderImage(),
            Column(
              children: [
                ResetPasswordTwoColoredHeaderText(),
                _emailDescriptionText(),
                _pinCodeFields(),
                _getCountdown(),
                _didNotReceiveCode(),
                _getProceedButton(),
                DidNotReceiveEmailFieldText(),
              ],
            )
          ],
        ),
      ),
    );
  }

  //Centered text
  Widget _emailDescriptionText() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          Text(
            "${translate(LangKeys.verifyEmailText)} ",
            textAlign: TextAlign.center,
            style: const TextStyle(color: ConstColors.text),
          ),
          Text(
            _getEmail(),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            style: const TextStyle(color: ConstColors.text),
          )
        ],
      ),
    );
  }

  //Pin code field
  Widget _pinCodeFields() {
    return Padding(
      padding: EdgeInsets.only(left: 45, right: 45, top: height / 30),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: PinCodeTextField(
          appContext: context,
          length: pinCodeTextFieldLength,
          controller: otpTextEditingController,
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
          animationDuration: const Duration(milliseconds: 300),
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

  //Countdown widget
  Widget _getCountdown() {
    return Padding(
      padding: EdgeInsets.only(top: height / 80),
      child: Text(
        "$minutes:$seconds",
        style: TextStyle(
          fontSize: 20,
          color: _countdownTimer.isActive
              ? ConstColors.accentColor
              : ConstColors.appGrey,
        ),
      ),
    );
  }

  //Didn't receive the code field
  Widget _didNotReceiveCode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(translate(LangKeys.doNotReceivedCode)),
        _resendButton(),
      ],
    );
  }

//Login button
  Widget _resendButton() {
    return TextButton(
      onPressed: _countdownTimer.isActive
          ? null
          : () {
              ForgetPasswordBloc.bloc(context).add(
                const ResendCodeForgetPasswordEvent(),
              );
            },
      child: Text(
        translate(LangKeys.resend),
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: _countdownTimer.isActive
              ? ConstColors.textGrey
              : ConstColors.txtButton,
        ),
      ),
    );
  }

  //Verify Email button
  Widget _getProceedButton() {
    return ForgetPasswordScreensButton(
      onPressed: !_isAllPinsAreSet
          ? null
          : () {
              ForgetPasswordBloc.bloc(context).add(
                ProceedForgetPasswordEvent(
                  code: otpTextEditingController.text,
                ),
              );
            },
      child: Text(translate(LangKeys.submit)),
    );
  }

  //Did not receive the email field
  Widget _didNotReceiveEmailField() {
    return Container(
      alignment: Alignment.center,
      padding:
          EdgeInsets.only(left: 24, right: 24, top: height / 35, bottom: 24),
      child: Center(
        child: Text.rich(
          TextSpan(
              text: translate(LangKeys.didNotReceiveEmail),
              style: const TextStyle(
                fontSize: 13,
                color: ConstColors.text,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: "\t${translate(LangKeys.editEmail)}",
                  style: const TextStyle(
                    fontSize: 13,
                    color: ConstColors.secondary,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Navigator.of(context).pop(),
                ),
              ]),
          textAlign: TextAlign.center,
        ),
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

  String _getEmail() {
    if (_email != null) {
      return _email!.replaceRange(0, _email!.indexOf("@") - 2, "*******");
    }
    return "";
  }
}
