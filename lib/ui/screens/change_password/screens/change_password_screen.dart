import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/api/models/change_password/change_password_send_model.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/auth/widgets/password_description_widget.dart';
import 'package:o7therapy/ui/screens/change_password/bloc/change_password_bloc.dart';
import 'package:o7therapy/ui/widgets/app_bar_more_screens/app_bar_more_screens.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';
import 'package:o7therapy/util/validator.dart';

class ChangePasswordScreen extends BaseScreenWidget {
  static const routeName = '/change-password-screen';

  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  BaseState screenCreateState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends BaseScreenState<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _oldPasswordFocusNode = FocusNode();
  final FocusNode _newPasswordFocusNode = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? userID;
  String currentPassword = "";
  String newPassword = "";
  bool obscure = true;
  bool setObscure = false;
  bool matchedPassword = false;
  bool isPasswordEmpty = true;
  bool isOldPasswordEmpty = true;
  bool isConfirmPasswordEmpty = true;

  ChangePasswordBloc get currentBloc =>
      BlocProvider.of<ChangePasswordBloc>(context);

  @override
  Widget buildScreenWidget(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBarForMoreScreens(
            title: translate(LangKeys.changePassword),
          ),
          body: _getBody()),
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

  Widget _getBody() {
    return BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
      listener: (context, state) {
        // show or hide loader
        if (state is Loading) {
          showLoading();
        } else {
          hideLoading();
        }
        if (state is PasswordEmptyError) {
          isPasswordEmpty = true;
        } else {
          isPasswordEmpty = false;
        }
        if (state is NetworkError) {
          if (state.message == "Session expired") {
            clearData();
            Navigator.of(context).pushNamedAndRemoveUntil(
                LoginScreen.routeName, (Route<dynamic> route) => false);
          }
          showToast(state.message);
        }
        if (state is ErrorState) {
          if (state.message == "Session expired") {
            clearData();
            Navigator.of(context).pushNamedAndRemoveUntil(
                LoginScreen.routeName, (Route<dynamic> route) => false);
          }
          showToast(state.message);
        }
        if (state is SuccessChangePassword) {
          showToast(translate(LangKeys.successChangePassword));
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 24.0, vertical: height / 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _oldPasswordFormField(),
                  _newPasswordFormField(),
                  _confirmPasswordFormField(),
                  PasswordDescriptionWidget(
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                  ),
                  _saveButton(state)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //Password form field
  Widget _oldPasswordFormField({String? errorPassword}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        obscureText: true,
        autocorrect: false,
        focusNode: _oldPasswordFocusNode,
        controller: _oldPasswordController,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          isDense: true,
          alignLabelWithHint: true,
          label: Text(
            translate(LangKeys.currentPassword),
            style: const TextStyle(
                color: ConstColors.text,
                fontWeight: FontWeight.w400,
                fontSize: 14),
          ),
          errorText: errorPassword,
          errorStyle: const TextStyle(color: ConstColors.error),
        ),
        onSaved: _onCurrentPasswordSubmitted,
        validator: (value) {
          /// not need to check the old pass is the same criteria or not
          /// only check if it is empty or not
          if (value == null || value.isEmpty) {
            return translate(LangKeys.passwordEmptyErr);
          } else {
            return null;
          }
        },
      ),
    );
  }

  //Password form field
  Widget _newPasswordFormField({String? errorPassword}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        obscureText: obscure,
        autocorrect: false,
        focusNode: _newPasswordFocusNode,
        controller: _passwordController,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          isDense: true,
          alignLabelWithHint: true,
          label: Text(
            translate(LangKeys.newPassword),
            style: const TextStyle(
                color: ConstColors.text,
                fontWeight: FontWeight.w400,
                fontSize: 14),
          ),
          errorText: errorPassword,
          errorStyle: const TextStyle(color: ConstColors.error),
          suffixIcon: IconButton(
            iconSize: 25,
            // Based on passwordVisible state choose the icon
            icon: obscure
                ? SvgPicture.asset(AssPath.hideEyeIcon)
                : SvgPicture.asset(AssPath.showEyeIcon),
            color: ConstColors.authSecondary,

            onPressed: () {
              // Update the state i.e.
              // toggle the state of passwordVisible variable
              setState(() {
                obscure = !obscure;
              });
            },
          ),
        ),
        onSaved: _onNewPasswordSubmitted,
        validator: (value) {
          if (value == null || value.isEmpty) {
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
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        controller: _confirmPasswordController,
        obscureText: obscure,
        autocorrect: false,
        decoration: InputDecoration(
          isDense: true,
          alignLabelWithHint: true,
          label: Text(
            translate(LangKeys.confirmNewPassword),
            style: const TextStyle(
                color: ConstColors.text,
                fontWeight: FontWeight.w400,
                fontSize: 14),
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
        onChanged: (value) {
          if (value == _passwordController.text) {
            setState(() {
              matchedPassword = true;
            });
          } else {
            setState(() {
              matchedPassword = false;
            });
          }
        },
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

  //Save button
  Widget _saveButton(ChangePasswordState state) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(
        top: height / 5,
        left: width / 5,
        right: width / 5,
      ),
      child: SizedBox(
        width: width,
        height: 45,
        child: ElevatedButton(
          onPressed:
              !isPasswordEmpty && !matchedPassword ? null : _onSavePressed,
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ))),
          child: Text(translate(LangKeys.save)),
        ),
      ),
    );
  }

///////////////////////////////////////////////////////////
/////////////////// Helper methods ////////////////////////
///////////////////////////////////////////////////////////

  void _onSavePressed() async {
    userID = await PrefManager.getId();
    debugPrint('save clicked');
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    currentBloc.add(ChangePasswordApiEvent(ChangePasswordSendModel(
        currentPassword: currentPassword,
        newPassword: newPassword,
        userId: await PrefManager.getId())));
  }

  void _onCurrentPasswordSubmitted(String? value) {
    currentPassword = value!;
  }

  void _onNewPasswordSubmitted(String? value) {
    newPassword = value!;
  }
}
