import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/api/mixpanel_manager.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/auth/forget_password/bloc/forget_password_bloc.dart';
import 'package:o7therapy/ui/screens/auth/forget_password/widgets/forget_password_screens_button.dart';
import 'package:o7therapy/ui/screens/auth/forget_password/widgets/reset_password_two_colored_header_text.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/auth/widgets/password_description_widget.dart';
import 'package:o7therapy/ui/screens/auth/widgets/two_colored_header_text.dart';
import 'package:o7therapy/ui/widgets/app_bar_more_screens/app_bar_more_screens.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/validator.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class CreateNewPasswordScreen extends BaseScreenWidget {
  static const routeName = '/create-new-password-screen';

  const CreateNewPasswordScreen({Key? key}) : super(key: key);

  @override
  BaseState<BaseStatefulWidget> screenCreateState() {
    return _CreateNewPasswordScreenState();
  }
}

class _CreateNewPasswordScreenState
    extends BaseScreenState<CreateNewPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _newPasswordObscure = true;

  final FocusNode _newPasswordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  late final Mixpanel _mixpanel;
  String? userReferenceNumber;

  @override
  void initState() {
    super.initState();
    _initMixpanel();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration.zero).then((_) {
      final args =
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      setState(() {
        userReferenceNumber = args['userReferenceNumber'];
      });
    });
  }
  Future<void> _initMixpanel() async {
    _mixpanel = await MixpanelManager.init();
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
    return SafeArea(
      child: BlocListener<ForgetPasswordBloc, ForgetPasswordState>(
        listener: (context, state) {
          if (state is LoadingForgetPasswordState) {
            showLoading();
          } else {
            hideLoading();
          }
          if (state is SuccessUpdatePasswordState) {
            Navigator.of(context).popUntil(
              (route) => route.settings.name == LoginScreen.routeName,
            );
          }
        },
        child: Scaffold(
          appBar: const AppBarForMoreScreens(
            color: Colors.transparent,
            title: '',
          ),
          resizeToAvoidBottomInset: true,
          body: _getNewPasswordAndConfirmPasswordContentColumn(),
        ),
      ),
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

  /// Get NewPassword And ConfirmPassword screen content column
  Widget _getNewPasswordAndConfirmPasswordContentColumn() {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(right: 24.0, left: 24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: TwoColoredHeaderText(
                  firstColoredText: translate(LangKeys.create),
                  secondColoredText: translate(LangKeys.newPassword)),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _getNewPasswordTextFormField(),
                  _getConfirmPasswordTextFormField(),
                  // _getDescriptionWidget(),
                  PasswordDescriptionWidget(
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                  )
                ],
              ),
            ),
            SizedBox(height: height * 0.3),
            _getSubmitNewPasswordButton(),
            SizedBox(height: height * 0.05),
          ],
        ),
      ),
    );
  }

  /// Get New Password auth text form field widget
  Widget _getNewPasswordTextFormField() {
    return _getPasswordTextFormFieldForCreateNewPasswordScreen(
      focusNode: _newPasswordFocusNode,
      controller: _passwordController,
      labelText: translate(LangKeys.newPassword),
      onSaved: _onNewPasswordTextSubmitted,
      validator: (value) {
        if (value!.isEmpty) {
          return translate(LangKeys.passwordEmptyErr);
        } else if (!Validator.isPassword(value)) {
          return translate(LangKeys.invalidPassword);
        }
        return null;
      },
    );
  }

  //Get Confirm Password auth text form field widget
  Widget _getConfirmPasswordTextFormField() {
    return _getPasswordTextFormFieldForCreateNewPasswordScreen(
      focusNode: _confirmPasswordFocusNode,
      controller: _confirmPasswordController,
      textInputAction: TextInputAction.done,
      labelText: translate(LangKeys.confirmPassword),
      validator: (value) {
        if (value != _passwordController.text) {
          return translate(LangKeys.passwordNotMatchErr);
        }
        return null;
      },
    );
  }

  /// Submit new Password button
  Widget _getSubmitNewPasswordButton() {
    return ForgetPasswordScreensButton(
      child: Text(translate(LangKeys.submit)),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _mixpanel.track("Create New Password",properties: {"User reference number":userReferenceNumber});
          ForgetPasswordBloc.bloc(context).add(
            SubmitNewPasswordEvent(
              newPassword: _passwordController.text,
            ),
          );
        }
      },
    );
  }

  /// get password Text Form Field for create new password screen
  Widget _getPasswordTextFormFieldForCreateNewPasswordScreen({
    required FocusNode focusNode,
    required TextEditingController controller,
    required String labelText,
    TextInputAction? textInputAction,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: height / 20),
      child: TextFormField(
        controller: controller,
        obscureText: _newPasswordObscure,
        autocorrect: false,
        focusNode: focusNode,
        style: const TextStyle(
          color: ConstColors.app,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        keyboardType: TextInputType.visiblePassword,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          isDense: true,
          alignLabelWithHint: true,
          contentPadding: EdgeInsets.zero,
          label: Text(
            labelText,
            style: const TextStyle(
                color: ConstColors.text,
                fontWeight: FontWeight.w400,
                fontSize: 14),
          ),
          // wait the error password update
          // errorText: "Oops! something went wrong with this password",
          errorStyle: const TextStyle(color: ConstColors.error),
          suffixIcon: IconButton(
            // Based on passwordVisible state choose the icon
            icon: _newPasswordObscure
                ? SvgPicture.asset(AssPath.hideEyeIcon)
                : SvgPicture.asset(AssPath.showEyeIcon),
            onPressed: () {
              setState(() => _newPasswordObscure = !_newPasswordObscure);
            },
          ),
        ),
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Helper methods ////////////////////////
  ///////////////////////////////////////////////////////////

  /// on New Password Text submitted
  void _onNewPasswordTextSubmitted(String? value) {
    FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
  }
}
