import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/api/models/profile/update_profile_send_model.dart';
import 'package:o7therapy/ui/screens/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:o7therapy/ui/screens/profile/widgets/bottom_sheets/custom_buttom_sheet_update_personal_info.dart';
import 'package:o7therapy/ui/screens/profile/widgets/custom_card.dart';
import 'package:o7therapy/ui/screens/profile/widgets/custom_rounded_button.dart';
import 'package:o7therapy/util/validator.dart';
import '../../../../api/models/auth/my_profile/my_profile_wrapper.dart';
import '../../../../res/const_colors.dart';
import '../../../../util/lang/app_localization_keys.dart';
import '../bloc/profile_bloc.dart';

class PersonalInfoWidget extends BaseScreenWidget {
  final MyProfileWrapper myProfileWrapper;

  PersonalInfoWidget({Key? key, required this.myProfileWrapper})
      : super(key: key);

  @override
  BaseState screenCreateState() => _PersonalInfoWidgetState();
}

class _PersonalInfoWidgetState extends BaseScreenState<PersonalInfoWidget> {
  @override
  Widget buildScreenWidget(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 1 / 40 * height,
        ),
        SizedBox(
          width: width * 50,
          height: 0.24 * height,
          child: CustomCard(
            labels: [
              translate(LangKeys.nameNickname),
              translate(LangKeys.dateOfBirth),
              translate(LangKeys.gender)
            ],
            values: [
              widget.myProfileWrapper.data?.name ??
                  translate(LangKeys.noInformation),
              _getBirthDate(),
              _getGenderValue(
                  gender: widget.myProfileWrapper.data?.gender ?? -1)
            ],
          ),
        ),
        SizedBox(
          height: 1 / 40 * height,
        ),
        CustomRoundedButton(
          text: translate(LangKeys.updateInfo),
          widthValue: width / 1.7,
          onPressed: () {
            String name = widget.myProfileWrapper.data?.name ?? "";
            String date = widget.myProfileWrapper.data!.dateOfBirth!;
            int gender = widget.myProfileWrapper.data?.gender ?? -1;

            _openBottomSheetUpdatePersonalInfo(context, name, date, gender);
          },
        ),
      ],
    );
  }

  String _getGenderValue({required int gender}) {
    switch (gender) {
      case 0:
        return translate(LangKeys.male);
        break;
      case 1:
        return translate(LangKeys.female);
        break;
      case 2:
        return translate(LangKeys.other);
        break;
      case 3:
        return translate(LangKeys.preferNotToSay);
        break;
    }
    return translate(LangKeys.noInformation);
  }

  String _getBirthDate() {
    if (widget.myProfileWrapper.data?.dateOfBirth != null) {
      String value = widget.myProfileWrapper.data?.dateOfBirth ??
          translate(LangKeys.noInformation);
      DateTime dateTime = DateTime.parse(value.substring(0, 8));
      var inputFormat = DateFormat('dd/MM/yyyy');

      String date = inputFormat.format(dateTime);
      return widget.myProfileWrapper.data?.dateOfBirth == "00010101000000"
          ? translate(LangKeys.noInformation)
          : date;
    } else {
      return translate(LangKeys.noInformation);
    }
  }

  _openBottomSheetUpdatePersonalInfo(
      context, String name, String date, int gender) {
    showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      )),
      builder: (BuildContext context) => Container(
        height: height - 360 + MediaQuery.of(context).viewInsets.bottom,
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: CustomBottomSheetUpdatePersonalInfo(
          name: name,
          date: date,
          gender: gender,
        ),
      ),
    );
  }
}
