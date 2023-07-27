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
import 'package:o7therapy/ui/screens/profile/widgets/custom_rounded_button.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';
import 'package:o7therapy/util/validator.dart';

enum UpdateProfileEnum {
  PersonalInfo,
  ContactInfo,
  EmergencyInfo,
  Other,
}

class CustomBottomSheetUpdatePersonalInfo extends BaseScreenWidget {
  final String name;
  final String date;
  final int gender;
  const CustomBottomSheetUpdatePersonalInfo(
      {Key? key, required this.name, required this.date, required this.gender})
      : super(key: key);
  @override
  BaseState screenCreateState() => _CustomBottomSheetUpdatePersonalInfoState();
}

class _CustomBottomSheetUpdatePersonalInfoState
    extends BaseScreenState<CustomBottomSheetUpdatePersonalInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _nickNameFocusNode = FocusNode();
  final TextEditingController _nickNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  String currentName = "";
  String selectedGender = "";
  String dateToSend = "";
  List<DropdownMenuItem<String>> get genderDropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          value: Gender.male.name, child: Text(translate(LangKeys.male))),
      DropdownMenuItem(
          value: Gender.female.name, child: Text(translate(LangKeys.female))),
      DropdownMenuItem(
          value: Gender.other.name, child: Text(translate(LangKeys.other))),
      DropdownMenuItem(
          value: Gender.preferNotToSay.name,
          child: Text(translate(LangKeys.preferNotToSay))),
    ];
    return menuItems;
  }

  ProfileBloc get currentBloc => BlocProvider.of<ProfileBloc>(context);
  DateTime? firstSelectedDate;
  bool canPressBack = true;
  @override
  void initState() {
    super.initState();
    _nickNameController.text = widget.name;
    // set date selected
    String dateWithT =
        '${(widget.date).substring(0, 8)}T${(widget.date).substring(8)}';
    DateTime dateTime = DateTime.parse(dateWithT);
    firstSelectedDate = dateTime;
    // set date to show
    DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    _dateOfBirthController.text =
        firstSelectedDate == DateTime.parse("0001-01-01 00:00:00.000")
            ? ""
            : dateFormat.format(firstSelectedDate!);
    //set date to send
    dateToSend = widget.date;
    _genderController.text = Gender.values.elementAt(widget.gender).name;
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(listener: (context, state) {
      if (state is LoadingToUpdatePersonalInfoState) {
        showLoading();
      } else {
        hideLoading();
      }
      if (state is SuccessUpdateProfilePersonalInfoState) {
        setState(() {
          canPressBack = true;
        });
        Navigator.of(context).pop();
        context.read<ProfileBloc>().add(const GetProfileInfoEvent());
        showToast(translate(LangKeys.updatedSuccessfully));
      }
      if (state is ExceptionUpdateProfilePersonalInfoState) {
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
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
                        translate(LangKeys.asteriskNickName),
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 11,
                            color: ConstColors.text),
                      ),
                      TextFormField(
                        controller: _nickNameController,
                        autocorrect: false,
                        focusNode: _nickNameFocusNode,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          isDense: true,
                          errorStyle: TextStyle(color: ConstColors.error),
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
                        translate(LangKeys.asteriskDateOfBirth),
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 11,
                            color: ConstColors.text),
                      ),
                      _getAgeDatePicker(),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Text(
                        translate(LangKeys.asteriskGender),
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 11,
                            color: ConstColors.text),
                      ),
                      _getDropdownGenderField(),
                      SizedBox(
                        height: height * 0.03,
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
                                    is ExceptionUpdateProfilePersonalInfoState) {
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
            if (state is ExceptionUpdateProfilePersonalInfoState) {
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
        firstName: _nickNameController.text,
        dateOfBirth: dateToSend,
        gender: _genderController.text,
        operation: UpdateProfileEnum.PersonalInfo.name);
    currentBloc.add(UpdateProfilePersonalInfoEvent(
        updateProfileSendModel: updateProfileSendModel));
  }

  Widget _getAgeDatePicker() {
    return InkWell(
      onTap: () => _selectDate(context),
      child: IgnorePointer(
        child: TextFormField(
          decoration: const InputDecoration(
              alignLabelWithHint: true,
              hintText: "dd/mm/yyyy",
              errorStyle: TextStyle(color: ConstColors.error),
              hintStyle: TextStyle(fontSize: 14)),
          controller: _dateOfBirthController,
          onSaved: (value) {},
          validator: (value) {
            if (_dateOfBirthController.text == null ||
                _dateOfBirthController.text.isEmpty) {
              return translate(LangKeys.ageEmptyErr);
            }
          },
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    AuthBloc authBloc = context.read<AuthBloc>();
    DateTime selectedDate =
        firstSelectedDate ?? authBloc.getDateTimeBefore18Years;
    print("firstSelectedDate");
    print(firstSelectedDate);
    final DateTime? newSelected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: authBloc.getDateTimeBefore18Years
          .subtract(const Duration(days: 365 * 100)),
      lastDate: authBloc.getDateTimeBefore18Years,
    );
    if (newSelected != null && newSelected != selectedDate) {
      setState(() {
        selectedDate = newSelected;
        firstSelectedDate = newSelected;
        _updateDateControllerText(selectedDate);
        authBloc.add(BirthDateChangedEvent(newSelected));
      });
    }
  }

  void _updateDateControllerText(DateTime? date) {
    if (date != null) {
      var dateFormatToSend = DateFormat('yyyyMMddHHmmss');
      String dateTime = dateFormatToSend.format(date);
      dateToSend = dateTime;
      var dateFormatToShow = DateFormat('dd/MM/yyyy');
      _dateOfBirthController.text = dateFormatToShow.format(date);
    }
  }

  Widget _getDropdownGenderField() {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      elevation: 5,
      dropdownColor: ConstColors.appWhite,
      hint: Text(
        _genderController.text,
      ),
      value: _genderController.text,
      decoration: const InputDecoration(
        fillColor: ConstColors.scaffoldBackground,
        enabled: true,
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: ConstColors.textDisabled)),
        disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ConstColors.textDisabled)),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ConstColors.textDisabled)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ConstColors.textDisabled)),
        errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ConstColors.textDisabled)),
        focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ConstColors.textDisabled)),
      ),
      onChanged: (String? newValue) {
        setState(() {
          selectedGender = newValue!;
        });
        _genderController.text = selectedGender;
      },
      items: genderDropdownItems,
      onSaved: (value) {},
      validator: (value) {
        if (value == null || value.isEmpty) {
          return translate(LangKeys.enterYourGender);
        }
      },
    );
  }
}
