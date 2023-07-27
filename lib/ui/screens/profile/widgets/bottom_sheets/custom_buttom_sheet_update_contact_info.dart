import 'package:country_picker/country_picker.dart' as cp;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/api/models/profile/update_profile_send_model.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/profile/bloc/profile_bloc.dart';
import 'package:o7therapy/ui/screens/profile/country/country_list.dart';
import 'package:o7therapy/ui/screens/profile/widgets/custom_rounded_button.dart';
import 'package:o7therapy/ui/screens/profile/widgets/phone_text_field.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';
import 'package:o7therapy/util/validator.dart';

enum UpdateProfileEnum {
  PersonalInfo,
  ContactInfo,
  EmergencyInfo,
  Other,
}

class CustomBottomSheetUpdateContactInfo extends BaseScreenWidget {
  final String phoneNumber;
  final String primaryEmail;
  final String secondaryEmail;
  const CustomBottomSheetUpdateContactInfo(
      {Key? key,
      required this.phoneNumber,
      required this.primaryEmail,
      required this.secondaryEmail})
      : super(key: key);
  @override
  BaseState screenCreateState() => _CustomBottomSheetUpdateContactInfoState();
}

class _CustomBottomSheetUpdateContactInfoState
    extends BaseScreenState<CustomBottomSheetUpdateContactInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _secondaryEmailFocusNode = FocusNode();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _secondaryEmailController =
      TextEditingController();

  ProfileBloc get currentBloc => BlocProvider.of<ProfileBloc>(context);
  bool canPressBack = true;
  String _currentCodeSelected = "";

  @override
  void initState() {
    super.initState();
    _codeController.text = widget.phoneNumber.contains("_")
        ? (widget.phoneNumber.isEmpty
            ? ""
            : widget.phoneNumber.substring(0, widget.phoneNumber.indexOf("_")))
        : "";

    _phoneNumberController.text = widget.phoneNumber.contains("_")
        ? (widget.phoneNumber.isEmpty
            ? ""
            : widget.phoneNumber.substring(
                widget.phoneNumber.indexOf("_") + 1, widget.phoneNumber.length))
        : "";
    _secondaryEmailController.text = widget.secondaryEmail;
    _currentCodeSelected = _codeController.text;
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(listener: (context, state) {
      if (state is LoadingToUpdateContactInfoState) {
        showLoading();
      } else {
        hideLoading();
      }
      if (state is SuccessUpdateProfileContactInfoState) {
        setState(() {
          canPressBack = true;
        });
        Navigator.of(context).pop();
        context.read<ProfileBloc>().add(const GetProfileInfoEvent());
        showToast(translate(LangKeys.updatedSuccessfully));
      }
      if (state is ExceptionUpdateProfileContactInfoState) {
        setState(() {
          canPressBack = true;
        });
        if (state.exception == "Session expired") {
          clearData();
          Navigator.of(context).pushNamedAndRemoveUntil(
              LoginScreen.routeName, (Route<dynamic> route) => false);
        }
        showToast(state.exception);
      }
    }, builder: (context, state) {
      return WillPopScope(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          translate(LangKeys.updateInformation),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: ConstColors.app,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Text(
                        translate(LangKeys.phoneNumber),
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 11,
                            color: ConstColors.text),
                      ),
                      PhoneTextField(
                        codeController: _codeController,
                        phoneNumberController: _phoneNumberController,
                        phoneNumberFocusNode: _phoneNumberFocusNode,
                      ),
                      // SizedBox(
                      //   height: height * 0.02,
                      // ),
                      // Text(
                      //   translate(LangKeys.primaryEmail),
                      //   style: const TextStyle(
                      //       fontWeight: FontWeight.w400,
                      //       fontStyle: FontStyle.normal,
                      //       fontSize: 11,
                      //       color: ConstColors.text),
                      // ),
                      // TextFormField(
                      //   controller: _primaryController,
                      //   autocorrect: false,
                      //   readOnly: true,
                      //   focusNode: _primaryEmailFocusNode,
                      //   textInputAction: TextInputAction.done,
                      //   decoration: const InputDecoration(
                      //     isDense: true,
                      //     errorStyle: TextStyle(color: ConstColors.error),
                      //   ),
                      // ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Text(
                        translate(LangKeys.secondaryEmail),
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 11,
                            color: ConstColors.text),
                      ),
                      TextFormField(
                        controller: _secondaryEmailController,
                        autocorrect: false,
                        focusNode: _secondaryEmailFocusNode,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: translate(LangKeys.secondaryEmail),
                          hintStyle: const TextStyle(fontSize: 12),
                          isDense: true,
                          errorStyle: const TextStyle(color: ConstColors.error),
                        ),
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            if (!Validator.isEmail(value)) {
                              return translate(LangKeys.invalidEmail);
                            }
                          }
                        },
                      ),
                      SizedBox(
                        height: height * 0.04,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: width / 3.9,
                          ),
                          CustomRoundedButton(
                              onPressed: () {
                                if (state
                                    is ExceptionUpdateProfileContactInfoState) {
                                  if (state.exception == "Session expired") {
                                    clearData();
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            LoginScreen.routeName,
                                            (Route<dynamic> route) => false);
                                    showToast(state.exception);
                                  } else {
                                    context
                                        .read<ProfileBloc>()
                                        .add(const GetProfileInfoEvent());
                                  }
                                }
                                Navigator.of(context).pop();
                              },
                              widthValue: width / 3.5,
                              isLight: true,
                              text: translate(LangKeys.cancel)),
                          SizedBox(
                            width: width * 0.01,
                          ),
                          CustomRoundedButton(
                              onPressed: () {
                                _onSaveButtonClicked();
                              },
                              widthValue: width / 3.5,
                              text: translate(LangKeys.save))
                        ],
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                    ],
                  ),
                )),
          ),
          onWillPop: () async {
            if (state is ExceptionUpdateProfileContactInfoState) {
              if (state.exception == "Session expired") {
                clearData();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    LoginScreen.routeName, (Route<dynamic> route) => false);
                showToast(state.exception);
              } else {
                context.read<ProfileBloc>().add(const GetProfileInfoEvent());
              }
            }
            return canPressBack;
          });
    });
  }

  _onSaveButtonClicked() {
    setState(() {
      canPressBack = false;
    });
    if (!_formKey.currentState!.validate()) {
      setState(() {
        canPressBack = true;
      });
      return;
    }
    _formKey.currentState!.save();
    print({
      "phoneNumber": "${_codeController.text}_${_phoneNumberController.text}",
      "countryCode": _codeController.text,
    });
    UpdateProfileSendModel updateProfileSendModel = UpdateProfileSendModel(
        phoneNumber: _phoneNumberController.text.isEmpty
            ? ""
            : "${_codeController.text}_${_phoneNumberController.text}",
        countryCode:
            _phoneNumberController.text.isEmpty ? "" : _codeController.text,
        secondaryEmail: _secondaryEmailController.text,
        operation: UpdateProfileEnum.ContactInfo.name);
    currentBloc.add(UpdateProfileContactInfoEvent(
        updateProfileSendModel: updateProfileSendModel));
  }
}
