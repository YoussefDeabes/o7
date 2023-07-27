import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/api/mixpanel_manager.dart';
import 'package:o7therapy/api/models/auth/check_verified_email/CheckVerifiedEmailData.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/res/const_values.dart';
import 'package:o7therapy/ui/screens/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:o7therapy/ui/screens/auth/widgets/did_not_receive_email_field_text.dart';
import 'package:o7therapy/ui/screens/auth/widgets/two_colored_header_text.dart';
import 'package:o7therapy/ui/screens/home/home_main_logged_in/home_main_logged_in/home_main_logged_in_screen.dart';
import 'package:o7therapy/ui/widgets/app_bar_more_screens/app_bar_more_screens.dart';
import 'package:o7therapy/util/firebase/analytics/auth_analytics.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../prefs/pref_manager.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

enum Gender { male, female, other, preferNotToSay }

class VerifyEmailScreen extends BaseScreenWidget {
  static const routeName = '/verify-email-screen';

  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  BaseState screenCreateState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends BaseScreenState<VerifyEmailScreen> {
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  final TextEditingController pinCodeTextController = TextEditingController();
  String userId = "";
  CheckVerifiedEmailData? data;
  bool firstTime = true;
  bool? isCorporate;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration.zero, () {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      userId = args['userId'] as String;
      data = args['data'] as CheckVerifiedEmailData?;
    });
  }

  late final Mixpanel _mixpanel;
  late Timer _timer;
  int _start = ConstValues.timerDuration;
  bool _isButtonDisabled = true;
  String? companyName;
  @override
  void initState() {
    startTimer();
    super.initState();
    _initMixpanel();
  }

  @override
  void dispose() {
    _timer.cancel();
    errorController.close();
    super.dispose();
  }

  Future<void> _initMixpanel() async {
    _mixpanel = await MixpanelManager.init();
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBarForMoreScreens(
          title: translate(LangKeys.verification),
          color: ConstColors.appWhite,
        ),
        resizeToAvoidBottomInset: true,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              height: height,
              width: width,
              color: ConstColors.appWhite,
            ),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is LoadingAuthState) {
                  showLoading();
                } else {
                  hideLoading();
                }
                if (state is NetworkError) {
                  showToast(state.message);
                } else if (state is ErrorState) {
                  showToast(state.message);
                } else if (state is SuccessVerifiedAuthState) {
                  companyName = state.companyName;
                  isCorporate = state.isCorporate;
                } else if (state is ClientProfile) {
                  _successValidation(state.profileInfo.accountType);
                } else if (state is SuccessCodeResentAuthState) {
                  setState(() {
                    _start = ConstValues.timerDuration;
                    _timer.cancel();
                    startTimer();
                  });
                  showToast(translate(LangKeys.codeResentSuccessfully));
                }
              },
              builder: (context, state) {
                return Center(
                  child: SizedBox(
                    width: width * 0.8,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              _verifyEmailPageImage(),
                              TwoColoredHeaderText(
                                  firstColoredText:
                                      translate(LangKeys.verifyTheEmail) + " ",
                                  secondColoredText:
                                      translate(LangKeys.yourEmail)),
                              _emailDescriptionText(),
                              _pinCodeFields(),
                              _getCountdown(
                                  "00:" + _start.toString().padLeft(2, '0'),
                                  20),
                              _didNotReceiveCode(),
                              _getVerifyEmailButton(),
                              DidNotReceiveEmailFieldText(),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

  Widget _verifyEmailPageImage() {
    return CircleAvatar(
      backgroundColor: ConstColors.appWhite,
      radius: MediaQuery.of(context).size.width / 4,
      child: SvgPicture.asset(
        AssPath.envelop,
        fit: BoxFit.cover,
      ),
    );
  }

  //Centered text
  Widget _emailDescriptionText() {
    return FutureBuilder<String?>(
      future: PrefManager.getEmail(),
      builder: (context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          String email = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(
              children: [
                Text(
                  "${translate(LangKeys.enterTheFiveDigitCode)} ",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: ConstColors.text),
                ),
                Text(
                  email.replaceRange(0, email.indexOf("@") - 2, "*******"),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(color: ConstColors.text),
                )
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  //Pin code field
  Widget _pinCodeFields() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: height / 30),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: PinCodeTextField(
          controller: pinCodeTextController,
          appContext: context,
          length: 5,
          textStyle: const TextStyle(color: ConstColors.text, fontSize: 25),
          obscureText: false,
          cursorColor: ConstColors.text,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          onChanged: (value) {
            if (value.length == 5) {
              _isButtonDisabled = false;
            } else {
              _isButtonDisabled = true;
            }
            setState(() {});
          },
        ),
      ),
    );
  }

  //Countdown widget
  Widget _getCountdown(String timeToWait, double fSize) {
    return Padding(
      padding: EdgeInsets.only(top: height / 80),
      child: Text(
        "$timeToWait ",
        style: TextStyle(
            fontSize: fSize,
            color: _start != 0 ? ConstColors.accentColor : ConstColors.appGrey),
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
      onPressed: _start != 0
          ? null
          : () {
              AuthBloc.bloc(context).add(
                ResendVerificationCodeAuthEvent(userId: userId),
              );
            },
      style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          alignment: Alignment.centerLeft),
      child: Text(
        translate(LangKeys.resend),
        style: TextStyle(
            decoration: TextDecoration.underline,
            color: _start != 0 ? null : ConstColors.txtButton),
      ),
    );
  }

  //Verify Email button
  Widget _getVerifyEmailButton() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: height / 40),
      child: SizedBox(
        width: width,
        height: 45,
        child: ElevatedButton(
          onPressed: _isButtonDisabled
              ? null
              : () {
                  AuthBloc.bloc(context).add(
                    VerifyClientEmailEvent(
                      code: pinCodeTextController.text,
                      userId: userId,
                    ),
                  );
                },
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ))),
          child: Text(translate(LangKeys.verifyEmail)),
        ),
      ),
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

  /// navigate to home screen for logged in user
  _successValidation(int? accountType) async {
    String? clientType = (isCorporate != null)
        ? (isCorporate! ? "corporate" : "individual")
        : null;
    AuthAnalytics.i.completedSignUp(
      isCorporate: isCorporate,
      corporateName: companyName,
    );
    _mixpanel.track("Completed Signup",
        properties: {"Client Type": clientType, "Corporate Name": companyName});
    Navigator.of(context).pushNamedAndRemoveUntil(
        HomeMainLoggedInScreen.routeName, (Route<dynamic> route) => false);
  }

  /// Setting Timer
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }
}
