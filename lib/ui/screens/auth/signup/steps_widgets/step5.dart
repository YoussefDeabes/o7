import 'dart:developer';

import 'package:adjust_sdk/adjust.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/auth/widgets/password_description_widget.dart';
import 'package:o7therapy/ui/screens/auth/widgets/two_colored_header_text.dart';
import 'package:o7therapy/ui/screens/get_started/get_started_screen.dart';
import 'package:o7therapy/ui/screens/web_view/web_view_screen.dart';
import 'package:o7therapy/ui/widgets/widgets.dart';
import 'package:o7therapy/util/firebase/analytics/auth_analytics.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/validator.dart';

class StepFive extends BaseStatefulWidget {
  const StepFive({Key? key})
      : super(
          key: key,
          backGroundColor: Colors.transparent,
        );

  @override
  BaseState<BaseStatefulWidget> baseCreateState() => _StepFiveState();
}

class _StepFiveState extends BaseState<StepFive> with WidgetsBindingObserver {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool obscure = true;
  bool setObscure = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  // final TextEditingController _phoneNumberController = TextEditingController();
  // final TextEditingController _codeController = TextEditingController();
  // final FocusNode _phoneNumberFocusNode = FocusNode();
  // String _currentCodeSelected = "";
  bool _emailValueisEmpty = true;
  bool _passwordValueisEmpty = true;
  bool _confirmPasswordValueisEmpty = true;

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
  Widget baseBuild(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              TwoColoredHeaderText(
                  firstColoredText: translate(LangKeys.create),
                  secondColoredText: translate(LangKeys.yourAccount)),
              Column(
                children: [
                  _emailFormField(),
                  // Padding(
                  //   padding: EdgeInsets.only(top: height / 40),
                  //   child: PhoneTextField(
                  //     codeController: _codeController,
                  //     phoneNumberController: _phoneNumberController,
                  //     phoneNumberFocusNode: _phoneNumberFocusNode,
                  //   ),
                  // ),
                  _passwordFormField(),
                  _confirmPasswordFormField(),
                  PasswordDescriptionWidget(
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                  ),
                  _signUpButton(),
                  // _continueWithRow(),
                  // _socialLogin(),
                  _termsAndConditions(),
                  _joinedBeforeRow(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Email form field
  Widget _emailFormField() {
    return Padding(
      padding: EdgeInsets.only(top: height / 80),
      child: TextFormField(
        onChanged: (value) {
          if (value.isEmpty) {
            setState(() {
              _emailValueisEmpty = true;
            });
          } else {
            setState(() {
              _emailValueisEmpty = false;
            });
          }
        },
        autocorrect: false,
        controller: _emailController,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          label: Text(
            translate(LangKeys.email),
            style: const TextStyle(color: ConstColors.text),
          ),
          errorStyle: const TextStyle(color: ConstColors.error),
        ),
        onSaved: (value) {},
        onEditingComplete: () {
          // FocusScope.of(context).requestFocus(_phoneNumberFocusNode);
        },
        validator: (value) {
          if (value!.isEmpty) {
            return translate(LangKeys.emailEmptyErr);
          } else if (!Validator.isEmail(value)) {
            return translate(LangKeys.invalidEmail);
          } else {
            return null;
          }
        },
      ),
    );
  }

  // Widget _getPhoneNumberFormField() {
  //   return
  // }

  //Password form field
  Widget _passwordFormField() {
    return Padding(
      padding: EdgeInsets.only(top: height / 40),
      child: TextFormField(
        onChanged: (value) {
          if (value.isEmpty) {
            setState(() {
              _passwordValueisEmpty = true;
            });
          } else {
            setState(() {
              _passwordValueisEmpty = false;
            });
          }
        },
        keyboardType: TextInputType.visiblePassword,
        obscureText: obscure,
        autocorrect: false,
        controller: _passwordController,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          isDense: true,
          // alignLabelWithHint: true,
          label: Text(
            translate(LangKeys.createPassword),
            style: const TextStyle(color: ConstColors.text),
          ),
          errorStyle: const TextStyle(color: ConstColors.error),
          // suffixIconConstraints: const BoxConstraints.tightFor(height: 16),
          suffixIcon: IconButton(
            // Based on passwordVisible state choose the icon
            icon: obscure
                ? SvgPicture.asset(AssPath.hideEyeIcon)
                : SvgPicture.asset(AssPath.showEyeIcon),
            // icon: Icon(
            //   // Based on passwordVisible state choose the icon

            //   obscure
            //       ? Icons.visibility_outlined
            //       : Icons.visibility_off_outlined,
            //   color: ConstColors.authSecondary,
            // ),
            onPressed: () {
              // Update the state i.e.
              // toggle the state of passwordVisible variable
              setState(() {
                obscure = !obscure;
              });
            },
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return translate(LangKeys.passwordEmptyErr);
          } else if (!Validator.isPassword(value)) {
            return translate(LangKeys.invalidOldPassword);
          } else {
            return null;
          }
        },
      ),
    );
  }

  //Confirm Password form field
  Widget _confirmPasswordFormField() {
    return Padding(
      padding: EdgeInsets.only(top: height / 40),
      child: TextFormField(
        onChanged: (value) {
          if (value.isEmpty) {
            setState(() {
              _confirmPasswordValueisEmpty = true;
            });
          } else {
            setState(() {
              _confirmPasswordValueisEmpty = false;
            });
          }
        },
        keyboardType: TextInputType.visiblePassword,
        controller: _confirmPasswordController,
        obscureText: obscure,
        autocorrect: false,
        decoration: InputDecoration(
          isDense: true,
          // alignLabelWithHint: true,
          label: Text(
            translate(LangKeys.confirmPassword),
            style: const TextStyle(color: ConstColors.text),
          ),
          errorStyle: const TextStyle(color: ConstColors.error),
          // suffixIconConstraints: const BoxConstraints.tightFor(height: 16),
          suffixIcon: IconButton(
            // Based on passwordVisible state choose the icon
            icon: obscure
                ? SvgPicture.asset(AssPath.hideEyeIcon)
                : SvgPicture.asset(AssPath.showEyeIcon),

            onPressed: () {
              // Update the state i.e.
              // toggle the state of passwordVisible variable
              setState(() {
                obscure = !obscure;
              });
            },
          ),
        ),
        onSaved: (value) {},
        validator: (value) {
          if (value!.isEmpty) {
            return translate(LangKeys.confirmPasswordEmptyErr);
          } else if (value != _passwordController.text) {
            return translate(LangKeys.passwordNotMatchErr);
          }

          return null;
        },
      ),
    );
  }

  //SingUp Button button
  Widget _signUpButton() {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: height / 20),
        child: SizedBox(
          width: width,
          height: 45,
          child: ElevatedButton(
            onPressed: _onSignupPressed,
            style: ButtonStyle(
              backgroundColor: (!_emailValueisEmpty &&
                      !_passwordValueisEmpty &&
                      !_confirmPasswordValueisEmpty)
                  ? MaterialStateProperty.all(ConstColors.app)
                  : MaterialStateProperty.all(ConstColors.disabled),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            child: Text(
              translate(
                LangKeys.signUp,
              ),
              style: TextStyle(
                color: (!_emailValueisEmpty &&
                        !_passwordValueisEmpty &&
                        !_confirmPasswordValueisEmpty)
                    ? Colors.white
                    : ConstColors.textDisabled,
              ),
            ),
          ),
        ));
  }

  //Continue with label
  Widget _continueWithRow() {
    return Padding(
      padding: EdgeInsets.only(top: height / 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          continueWithLineDivider(height: 1, width: width / 8),
          Text(
            translate(LangKeys.continueWith),
            style: const TextStyle(
                color: ConstColors.app,
                fontWeight: FontWeight.w500,
                fontSize: 14),
          ),
          continueWithLineDivider(height: 1, width: width / 10),
        ],
      ),
    );
  }

  //Social and apple Id login row
  Widget _socialLogin() {
    return Padding(
      padding: EdgeInsets.only(top: height / 25),
      child: defaultTargetPlatform == TargetPlatform.iOS
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _appleIdButton(),
                SizedBox(width: width / 4),
                _googleLoginButton(),
              ],
            )
          : _googleLoginButton(),
    );
  }

  //Apple ID button
  Widget _appleIdButton() {
    return Column(
      children: [
        FloatingActionButton(
          heroTag: 'appleId',
          onPressed: () {},
          elevation: 5,
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.apple,
            color: Colors.black,
            size: 40,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text(
            translate(LangKeys.appleId),
            style: const TextStyle(fontSize: 14, color: ConstColors.text),
          ),
        ),
      ],
    );
  }

  //Google login button
  Widget _googleLoginButton() {
    return Column(
      children: [
        FloatingActionButton(
          heroTag: 'googleLogin',
          onPressed: () {},
          elevation: 5,
          backgroundColor: Colors.white,
          child: Image.asset(AssPath.googleIcon),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text(
            translate(LangKeys.google),
            style: const TextStyle(fontSize: 14, color: ConstColors.text),
          ),
        ),
      ],
    );
  }

  //Terms & Condistions
  Widget _termsAndConditions() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: height / 30),
      child: Center(
        child: Text.rich(
          TextSpan(
              text:
                  "${translate(LangKeys.byCreatingAnAccountYouAreAgreeingToOur)}\t",
              style: const TextStyle(
                fontSize: 13,
                color: ConstColors.text,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: translate(LangKeys.termsAndConditions),
                    style: const TextStyle(
                      fontSize: 13,
                      color: ConstColors.secondary,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Navigator.pushNamed(
                          context, WebViewScreen.routeName,
                          arguments:
                              "https://o7therapy.com/mobile-terms-and-conditions/")),
                TextSpan(
                    text: ' ${translate(LangKeys.and)} ',
                    style:
                        const TextStyle(fontSize: 13, color: ConstColors.text),
                    children: <TextSpan>[
                      TextSpan(
                          text: translate(LangKeys.privacyPolicy),
                          style: const TextStyle(
                              fontSize: 13,
                              color: ConstColors.secondary,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.pushNamed(
                                context, WebViewScreen.routeName,
                                arguments:
                                    "https://o7therapy.com/mobile-privacy-policy/"))
                    ])
              ]),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  //Joined before row for login route
  Widget _joinedBeforeRow() {
    return Padding(
      padding: EdgeInsets.only(top: height / 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            translate(LangKeys.alreadyHaveAProfile),
            style: const TextStyle(
                color: ConstColors.text,
                fontWeight: FontWeight.w500,
                fontSize: 16),
          ),
          _loginButton(),
        ],
      ),
    );
  }

  /// Login button that move the user to the login screen
  Widget _loginButton() {
    return TextButton(
      onPressed: () {
        context.read<AuthBloc>().reset();
        Navigator.of(context).pushNamedAndRemoveUntil(
          LoginScreen.routeName,
          (route) => route.settings.name == GetStartedScreen.routeName,
        );
      },
      style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          alignment: Alignment.centerLeft),
      child: Text(
        translate(LangKeys.login),
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          decoration: TextDecoration.underline,
          color: ConstColors.txtButton,
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////
  AuthBloc get currentBloc => context.read<AuthBloc>();

  /// when the user press on signUp
  void _onSignupPressed() {
    if (_emailController.text.isEmpty &&
        _passwordController.text.isEmpty &&
        _confirmPasswordController.text.isEmpty) {
    } else {
      AuthAnalytics.i.signUpClick();
      // Navigator.of(context).pushNamed(VerifyEmailScreen.routeName);
      debugPrint('SignUP clicked');

      /// not valid state will return
      if (!_formKey.currentState!.validate()) {
        return;
      }
      _formKey.currentState!.save();
      currentBloc.add(SignupApiEvent(
        // phoneNumber: "${_codeController.text}_${_phoneNumberController.text}",
        email: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      ));
    }
  }
}
