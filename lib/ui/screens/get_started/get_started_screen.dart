import 'package:adjust_sdk/adjust.dart';
import 'package:flutter/material.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/api/adjust_manager.dart';
import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/api/mixpanel_manager.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/auth/signup/signup_screen.dart';
import 'package:o7therapy/ui/screens/get_started/widgets/slider_section.dart';
import 'package:o7therapy/ui/screens/home/home_main/home_main_screen.dart';
import 'package:o7therapy/util/firebase/analytics/auth_analytics.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/ui/screen_controller.dart';

class GetStartedScreen extends BaseScreenWidget {
  static const routeName = '/get-started-screen';

  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  BaseState<BaseScreenWidget> screenCreateState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends BaseScreenState<GetStartedScreen>
    with WidgetsBindingObserver {
  late final Mixpanel _mixpanel;

  @override
  void initState() {
    exitFullScreen();
    super.initState();
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
    return Scaffold(
      backgroundColor: ConstColors.appWhite,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SliderSection(),
              _getStartedButton(),
              _joinedBeforeRow(),
              _registerLaterButton(),
              SizedBox(height: height * 0.05)
            ],
          ),
        ),
      ),
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

//Background Image
  Widget _getBg() {
    return SizedBox(
      height: height,
      width: width,
      child: Image.asset(
        AssPath.bg,
        fit: BoxFit.fill,
      ),
    );
  }

//Heading text for get started slider
  Widget _headingTextWidget(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: ConstColors.appTitle,
          fontSize: 20),
    );
  }

//Description of get started slider
  Widget _getDescriptionWidget(String text) {
    return SizedBox(
      width: 250,
      child: RichText(
        text: TextSpan(
            text: text,
            style: const TextStyle(color: ConstColors.text, fontSize: 16)),
        textAlign: TextAlign.center,
      ),
    );
  }

//Get started button
  Widget _getStartedButton() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 20.0),
      child: SizedBox(
        width: width,
        height: 45,
        child: ElevatedButton(
          onPressed: () {
            AuthAnalytics.i.getStartedClick();
            _mixpanel.track("Get Started");
            Adjust.trackEvent(AdjustManager.buildSimpleEvent(
                eventToken: ApiKeys.getStartedEventToken));
            Navigator.of(context).pushNamed(SignupScreen.routeName);
          },
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ))),
          child: Text(translate(LangKeys.startNow),
              style:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        ),
      ),
    );
  }

//Joined before row for login route
  Widget _joinedBeforeRow() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            translate(LangKeys.alreadyHaveAProfile),
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          _loginButton(),
        ],
      ),
    );
  }

//Login button
  Widget _loginButton() {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushNamed(LoginScreen.routeName);
      },
      style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          alignment: Alignment.centerLeft),
      child: Text(
        translate(LangKeys.login),
        style: const TextStyle(
            decoration: TextDecoration.underline,
            color: ConstColors.txtButton,
            fontSize: 14,
            fontWeight: FontWeight.w500),
      ),
    );
  }

//Register later "Skip" button
  Widget _registerLaterButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextButton(
        onPressed: () {
          AuthAnalytics.i.registerLaterClick();
          _mixpanel.track("Register later");
          Navigator.of(context).pushReplacementNamed(HomeMainScreen.routeName);
        },
        child: Text(
          translate(LangKeys.registerLater),
          style: const TextStyle(
              decoration: TextDecoration.underline,
              color: ConstColors.txtButton,
              fontSize: 14,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Future<void> _initMixpanel() async {
    _mixpanel = await MixpanelManager.init();
    _mixpanel.unregisterSuperProperty("User Reference Number");
  }
}
