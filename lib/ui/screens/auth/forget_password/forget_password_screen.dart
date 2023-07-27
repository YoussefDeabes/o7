import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/api/mixpanel_manager.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/auth/forget_password/bloc/forget_password_bloc.dart';
import 'package:o7therapy/ui/screens/auth/forget_password/verify_email_for_forget_password_screen.dart';
import 'package:o7therapy/ui/screens/auth/forget_password/widgets/forget_password_screens_button.dart';
import 'package:o7therapy/ui/screens/auth/forget_password/widgets/reset_password_header_image.dart';
import 'package:o7therapy/ui/screens/auth/forget_password/widgets/reset_password_two_colored_header_text.dart';
import 'package:o7therapy/ui/widgets/app_bar_more_screens/app_bar_more_screens.dart';

import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';
import 'package:o7therapy/util/ui/screen_controller.dart';
import 'package:o7therapy/util/validator.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class ForgetPasswordScreen extends BaseScreenWidget {
  static const routeName = '/forget-password-screen';

  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  BaseState screenCreateState() {
    return _ForgetPasswordScreenState();
  }
}

class _ForgetPasswordScreenState extends BaseScreenState<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  late final Mixpanel _mixpanel;

  @override
  void initState() {
    _initMixpanel();
    exitFullScreen();
    super.initState();
  }
  Future<void> _initMixpanel() async {
    _mixpanel = await MixpanelManager.init();
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
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
            if (state is ExceptionForgetPasswordState) {
              _mixpanel.track("Forget Password",properties: {"status":state.msg});
              showToast(state.msg);
            } else if (state is SuccessSendEmailState) {
              _mixpanel.track("Forget Password",properties: {"status":"valid email"});
              Navigator.of(context).pushNamed(
                VerifyEmailForForgetPasswordScreen.routeName,
                arguments: _emailTextEditingController.text,
              );
            }
          },
          // forgetPasswordListener(context, state, showLoading, hideLoading),
          child: Scaffold(
            appBar: const AppBarForMoreScreens(
              title: '',
              color: Colors.transparent,
            ),
            resizeToAvoidBottomInset: true,
            backgroundColor: ConstColors.appWhite,
            body: _getForgetPasswordContentColumn(),
          ),
        ),
      ),
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

//Get Forget password screen content column
  Widget _getForgetPasswordContentColumn() {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(right: 24.0, left: 24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const ResetPasswordHeaderImage(),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  ResetPasswordTwoColoredHeaderText(),
                  _getDescriptionWidget(translate(
                      LangKeys.enterTheEmailAssociatedWithYourAccount)),
                  _getEmailTextField(),
                  _getSendEmailButton(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //Get email text field
  Widget _getEmailTextField() {
    return Padding(
      padding: EdgeInsets.only(
        top: height / 30,
      ),
      child: TextFormField(
        autocorrect: false,
        controller: _emailTextEditingController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          hintText: translate(LangKeys.enterEmail),
          hintStyle: const TextStyle(fontSize: 12, color: ConstColors.appGrey),
          label: Text(
            translate(LangKeys.email),
            style: const TextStyle(
              color: ConstColors.text,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
          errorStyle: const TextStyle(color: ConstColors.error),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
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

//Description of get started slider
  Widget _getDescriptionWidget(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text.rich(
        TextSpan(
            text: text,
            style: const TextStyle(color: ConstColors.text, fontSize: 16)),
        textAlign: TextAlign.center,
      ),
    );
  }

//Send Email button
  Widget _getSendEmailButton() {
    return ForgetPasswordScreensButton(
      child: Text(translate(LangKeys.sendEmail)),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
             ForgetPasswordBloc.bloc(context).add(
            SendEmailForgetPasswordEvent(
              email: _emailTextEditingController.text,
            ),
          );
        }
      },
    );
  }
}
