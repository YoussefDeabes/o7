import 'package:country_picker/country_picker.dart' as cp;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/api/models/auth/sign_up_models/sign_up_send_model.dart';
import 'package:o7therapy/api/models/profile/update_profile_send_model.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/auth/bloc/auth_bloc/auth_bloc.dart';
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

enum RelationsEnum {
  Father,
  Mother,
  Brother,
  Sister,
  Son,
  Daughter,
  Relative,
  Friend,
  Other
}

class CustomBottomSheetUpdateEmergencyContactInfo extends BaseScreenWidget {
  final String name;
  final String phoneNumber;
  final String email;
  final int relationship;
  const CustomBottomSheetUpdateEmergencyContactInfo(
      {Key? key,
      required this.name,
      required this.phoneNumber,
      required this.email,
      required this.relationship})
      : super(key: key);
  @override
  BaseState screenCreateState() =>
      _CustomBottomSheetUpdateEmergencyContactInfoState();
}

class _CustomBottomSheetUpdateEmergencyContactInfoState
    extends BaseScreenState<CustomBottomSheetUpdateEmergencyContactInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _relationshipController = TextEditingController();
  String selectedRelationship = "";
  String _currentCodeSelected = "";
  String _selectedRelationShipVal = "";
  final TextEditingController _codeController = TextEditingController();

  List<DropdownMenuItem<String>> get relationshipDropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
        value: RelationsEnum.Father.name,
        child: Text(
          translate(LangKeys.father),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
        ),
      ),
      DropdownMenuItem(
          value: RelationsEnum.Mother.name,
          child: Text(
            translate(LangKeys.mother),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          )),
      DropdownMenuItem(
          value: RelationsEnum.Brother.name,
          child: Text(
            translate(LangKeys.brother),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          )),
      DropdownMenuItem(
          value: RelationsEnum.Sister.name,
          child: Text(
            translate(LangKeys.sister),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          )),
      DropdownMenuItem(
          value: RelationsEnum.Son.name,
          child: Text(
            translate(LangKeys.son),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          )),
      DropdownMenuItem(
          value: RelationsEnum.Daughter.name,
          child: Text(
            translate(LangKeys.daughter),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          )),
      DropdownMenuItem(
          value: RelationsEnum.Relative.name,
          child: Text(
            translate(LangKeys.relative),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          )),
      DropdownMenuItem(
          value: RelationsEnum.Friend.name,
          child: Text(
            translate(LangKeys.friend),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          )),
      DropdownMenuItem(
          value: RelationsEnum.Other.name,
          child: Text(
            translate(LangKeys.other),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          )),
    ];
    return menuItems;
  }

  ProfileBloc get currentBloc => BlocProvider.of<ProfileBloc>(context);
  DateTime? firstselectedDate = null;
  bool canPressBack = true;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
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

    _emailController.text = widget.email;
    String key =
        RelationsEnum.values.elementAt(widget.relationship).name.toLowerCase();
    Future.delayed(Duration.zero, () {
      _relationshipController.text =
          widget.relationship == -1 ? "" : translate(key);
    });
    // relation value to send to api
    _selectedRelationShipVal = widget.relationship == -1
        ? ""
        : RelationsEnum.values.elementAt(widget.relationship).name;
    _currentCodeSelected = _codeController.text;
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(listener: (context, state) {
      if (state is LoadingToUpdateEmergencyContactInfoState) {
        showLoading();
      } else {
        hideLoading();
      }
      if (state is SuccessUpdateProfileEmergencyContactInfoState) {
        setState(() {
          canPressBack = true;
        });
        Navigator.of(context).pop();
        context.read<ProfileBloc>().add(const GetProfileInfoEvent());
        showToast(translate(LangKeys.updatedSuccessfully));
      }
      if (state is ExceptionUpdateProfileEmergencyContactInfoState) {
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
                //the next line Fix Error message appear when open update Emergency contact
                autovalidateMode: AutovalidateMode.disabled,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.01,
                      ),
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
                        height: height * 0.02,
                      ),
                      Text(
                        translate(LangKeys.nameAsterisk),
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 11,
                            color: ConstColors.text),
                      ),
                      TextFormField(
                        controller: _nameController,
                        autocorrect: false,
                        focusNode: _nameFocusNode,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: translate(LangKeys.name),
                          hintStyle: const TextStyle(fontSize: 12),
                          errorStyle: const TextStyle(color: ConstColors.error),
                        ),
                        // onSaved: _onCurrentPasswordSubmitted,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return translate(LangKeys.nameNicknameEmptyErr);
                          }
                        },
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Text(
                        translate(LangKeys.asteriskPhoneNumber),
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
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Text(
                        translate(LangKeys.email),
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 11,
                            color: ConstColors.text),
                      ),
                      TextFormField(
                        controller: _emailController,
                        autocorrect: false,
                        focusNode: _emailFocusNode,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: translate(LangKeys.email),
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
                        height: height * 0.02,
                      ),
                      Text(
                        translate(LangKeys.relationshipAsterisk),
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 11,
                            color: ConstColors.text),
                      ),
                      _getDropdownRelationshipField(),
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
                                    is ExceptionUpdateProfileEmergencyContactInfoState) {
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
                          SizedBox(width: width * 0.02),
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
            if (state is ExceptionUpdateProfileEmergencyContactInfoState) {
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
    UpdateProfileSendModel updateProfileSendModel = UpdateProfileSendModel(
        contactPersonName: _nameController.text,
        contactPersonEmail: _emailController.text,
        contactPersonPhoneNumber: _phoneNumberController.text.isEmpty
            ? ""
            : "${_codeController.text}_${_phoneNumberController.text}",
        contactPersonCountryCode:
            _phoneNumberController.text.isEmpty ? "" : _codeController.text,
        contactPersonRelationship: _selectedRelationShipVal,
        operation: UpdateProfileEnum.EmergencyInfo.name);
    currentBloc.add(UpdateProfileEmergenceContactInfoEvent(
        updateProfileSendModel: updateProfileSendModel));
  }

  Widget _getDropdownRelationshipField() {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: List.generate(
                        relationshipDropdownItems.length,
                        (index) => InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              _selectedRelationShipVal =
                                  relationshipDropdownItems[index].value!;
                              _relationshipController.text = translate(
                                  relationshipDropdownItems[index]
                                      .value!
                                      .toLowerCase());
                            },
                            child: Container(
                                alignment: Alignment.center,
                                width: width,
                                margin: const EdgeInsets.only(top: 50),
                                child:
                                    relationshipDropdownItems[index].child))),
                  ),
                ));
      },
      child: TextFormField(
        controller: _relationshipController,
        autocorrect: false,
        enabled: false,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          isDense: true,
          hintText: translate(LangKeys.relationship),
          hintStyle: const TextStyle(fontSize: 12),
          errorStyle: const TextStyle(color: ConstColors.error),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return translate(LangKeys.relationEmptyErr);
          }
        },
      ),
    );
  }
}
