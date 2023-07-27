import 'dart:developer';

import 'package:adjust_sdk/adjust.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/api/adjust_manager.dart';
import 'package:o7therapy/api/mixpanel_manager.dart';
import 'package:o7therapy/api/models/auth/check_verified_email/CheckVerifiedEmailData.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/auth/bloc/auth_bloc/auth_bloc.dart';

import 'package:o7therapy/ui/screens/auth/signup/steps_widgets/step1.dart';
import 'package:o7therapy/ui/screens/auth/signup/steps_widgets/step2.dart';
import 'package:o7therapy/ui/screens/auth/signup/steps_widgets/step3.dart';
import 'package:o7therapy/ui/screens/auth/signup/steps_widgets/step4.dart';
import 'package:o7therapy/ui/screens/auth/signup/steps_widgets/step5.dart';
import 'package:o7therapy/ui/screens/auth/signup/verify_email_screen.dart';
import 'package:o7therapy/ui/screens/splash/cubit/refresh_token_cubit.dart';
import 'package:o7therapy/ui/widgets/stepper_widget/model/stepper_item.dart';
import 'package:o7therapy/ui/widgets/stepper_widget/view/stepper_view.dart';
import 'package:o7therapy/util/firebase/analytics/auth_analytics.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';

class SignupScreen extends BaseScreenWidget {
  static const routeName = '/signup-screen';

  const SignupScreen({Key? key}) : super(key: key);

  @override
  BaseState screenCreateState() => _SignupScreenState();
}

class _SignupScreenState extends BaseScreenState<SignupScreen>
    with WidgetsBindingObserver {
  int currentStepIndex = 0;
  DateTime? currentBackPressTime;
  late final Mixpanel _mixpanel;

  @override
  void initState() {
    AuthBloc authBloc = context.read<AuthBloc>();
    RefreshTokenCubit.cubit(context).reset();

    authBloc.reset();
    super.initState();
    // Track with event-name
    _initMixpanel();
    WidgetsBinding.instance.addObserver(this);
    AdjustManager.initPlatformState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        Adjust.onResume();
        break;
      case AppLifecycleState.paused:
        Adjust.onPause();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: WillPopScope(child: _getBody(), onWillPop: onWillPop),
      ),
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

  Widget _getBody() {
    return Stack(
      fit: StackFit.expand,
      children: [
        _getBg(),
        SafeArea(child: _getScreenContentColumn()),
      ],
    );
  }

  //Background Image
  Widget _getBg() {
    return Container(
      height: height,
      width: width,
      color: ConstColors.appWhite,
      // child:
      // Image.asset(
      //   AssPath.bg,
      //   fit: BoxFit.fill,
      // ),
    );
  }

  //Screen content column
  Widget _getScreenContentColumn() {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        log("listen to current state : $state ");
        if (state is LoadingAuthState) {
          showLoading();
        } else {
          hideLoading();
        }
        if (state is SignUpStepsExceptionState) {
          showToast(translate(state.exception.detailedMsg), ConstColors.appGrey,
              Colors.black);
        }
        if (state is NetworkError) {
          showToast(state.message);
        } else if (state is ErrorState) {
          showToast(state.message, ConstColors.appGrey);
        } else if (state is VerifiedEmailAfterSignupScreenAuthState &&
            state.isVerified == false) {
          _notVerifiedState(state.userId, state.date);
        }
      },
      child: _getStepperWidget(),
    );
  }

  //Stepper
  Widget _getStepperWidget() {
    return StepperView(
      progressStyle: const TextStyle(color: ConstColors.accent, fontSize: 16),
      controlBuilder: (onNext, onBack) {
        return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          if (state is SigupUpdateStepIndex) {
            if (state.newStepIndex > state.currentStepIndex) {
              onNext();
            } else {
              onBack();
            }
            currentStepIndex = state.newStepIndex;
            context.read<AuthBloc>().add(ChangeStepEvent(
                  currentStepNumber: state.newStepIndex,
                ));
          }

          return Padding(
              padding: const EdgeInsets.only(left: 14.0, right: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  currentStepIndex < 1
                      ? Container()
                      : IconButton(
                          onPressed: () {
                            if (currentStepIndex == 0) {
                              enablePop();
                            } else {
                              _changeStepPressed(
                                  comingStepIndex: currentStepIndex - 1);
                            }
                          },
                          color: ConstColors.app,
                          icon: const Icon(Icons.arrow_back_ios_sharp),
                        ),
                  currentStepIndex >= 4
                      ? Container()
                      : IconButton(
                          onPressed: () => _changeStepPressed(
                              comingStepIndex: currentStepIndex + 1),
                          color: ConstColors.app,
                          icon: const Icon(Icons.arrow_forward_ios_sharp)),
                ],
              ));
        });
      },
      // onStepChanged: (int page) {
      //   log("next page  $page");

      //   // setState(() => currentStepIndex = comingStepIndex);
      // },
      steps: [
        StepperItem(label: translate(LangKeys.step1), content: StepOne()),
        StepperItem(label: translate(LangKeys.step2), content: const StepTwo()),
        StepperItem(
            label: translate(LangKeys.step3), content: const StepThree()),
        StepperItem(
            label: translate(LangKeys.step4), content: const StepFour()),
        StepperItem(
            label: translate(LangKeys.step5), content: const StepFive()),
      ],
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  /// this function called when the user tried to click next or back
  _changeStepPressed({required int comingStepIndex}) {
    AuthBloc authBloc = context.read<AuthBloc>();
    authBloc.add(CheckStepEvent(
      comingStepNumber: comingStepIndex,
      currentStepNumber: currentStepIndex,
    ));
    log("state when _changeStepPressed:: ${authBloc.state}");
    hideLoading();
  }

  _notVerifiedState(String userId, CheckVerifiedEmailData? data) {
    /// will remove all routes and navigate to onBoarding screen
    /// then it will push name to verify screen
    /// so if he will back from verify will back to onBoarding
    _mixpanel.track("Registration / Sign Up");

    ///
    DateTime? dateOfBirth =
        data?.dob != null ? DateTime.parse(data!.dob!) : null;
    print("--------------------------Signup unverified ---- sign up");
    String dateToSend =
        "${dateOfBirth?.day}/${dateOfBirth?.month}/${dateOfBirth?.year}";
    String? gender = data?.gender != null
        ? Gender.values.elementAt(data!.gender!).name
        : null;
    List<String?>? therapyGoal =
        data?.clientGoals != null ? data!.clientGoals! : null;

    AuthAnalytics.i.unverifiedSignUp();
    _mixpanel.track("Signup unverified", properties: {
      "Gender": gender,
      "Date Of Birth": dateToSend,
      "I Want to(Therapy goal)": therapyGoal,
    });

    Navigator.of(context).pushNamedAndRemoveUntil(
      VerifyEmailScreen.routeName,
          (Route<dynamic> route) => false,
      arguments: {
        "userId": userId,
        "date": data,
      },
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime ?? now) >
            const Duration(seconds: 3)) {
      currentBackPressTime = now;
      showToast(translate(LangKeys.pressAgainToExitSignUp));
      return Future.value(false);
    } else {
      AuthBloc authBloc = context.read<AuthBloc>();
      authBloc.reset();
      return Future.value(true);
    }
  }

  void enablePop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime ?? now) >
            const Duration(seconds: 3)) {
      currentBackPressTime = now;
      showToast(translate(LangKeys.pressAgainToExitSignUp));
      return;
    } else {
      AuthBloc authBloc = context.read<AuthBloc>();
      authBloc.reset();
      return Navigator.pop(context);
    }
  }

  Future<void> _initMixpanel() async {
    _mixpanel = await MixpanelManager.init();
  }
}
