import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/auth/signup/signup_screen.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/footer_widget.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/header_text_widget.dart';
import 'package:o7therapy/ui/screens/more_guest/widgets/text_buttons_List.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class MoreGuestScreen extends BaseStatefulWidget {
  static const routeName = '/more-guest-screen';
  const MoreGuestScreen({Key? key}) : super(key: key);

  @override
  BaseState<BaseStatefulWidget> baseCreateState() => _MoreGuestScreenState();
}

class _MoreGuestScreenState extends BaseState<MoreGuestScreen> {
  @override
  Widget baseBuild(BuildContext context) {
    return _getBody();
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

  /// get the body of the screen
  Widget _getBody() {
    return Container(
      alignment: AlignmentDirectional.topStart,
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      child: _getMoreGuestScreenContent(),
    );
  }

  // the content of the More screen
  Widget _getMoreGuestScreenContent() {
    return SafeArea(
      child: Column(
        children: [
          Align(
              alignment: AlignmentDirectional.centerStart,
              child: HeaderWidget(
                text: translate(LangKeys.more),
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
              )),
          SizedBox(height: height * 0.044),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _getReadyForYourWellnessJourneySection(),
                  SizedBox(height: height * 0.044),
                  _getStartNowButton(),
                  _joinedBeforeRow(),
                  SizedBox(height: height * 0.03),
                  TextButtonsList(),
                  const FooterWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

  /// get the ready for your wellness journey
  /// Hi, ready for your wellness journey to begin?
  Widget _getReadyForYourWellnessJourneySection() {
    return Container(
      alignment: Alignment.center,
      width: width * 0.70,
      child: Text(
        translate(LangKeys.createYourProfileToSeeMore),
        style: const TextStyle(
            color: ConstColors.app, fontSize: 16, fontWeight: FontWeight.w600),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// get Services Start Now button
  Widget _getStartNowButton() {
    return Container(
      alignment: Alignment.center,
      width: width * 0.70,
      child: SizedBox(
        width: width,
        height: 45,
        child: ElevatedButton(
          onPressed: () =>
              Navigator.of(context).pushNamed(SignupScreen.routeName),
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ))),
          child: Text(translate(LangKeys.signUp)),
        ),
      ),
    );
  }

  //Already have a profile
  Widget _joinedBeforeRow() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 24, right: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _getTextWidget(translate(LangKeys.alreadyHaveAProfile)),
          _loginButton(),
        ],
      ),
    );
  }

  Widget _getTextWidget(String text) {
    return Text(
      text,
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
            decoration: TextDecoration.underline, color: ConstColors.txtButton),
      ),
    );
  }
}
