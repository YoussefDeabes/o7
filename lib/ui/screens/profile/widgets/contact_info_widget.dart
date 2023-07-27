import 'package:flutter/material.dart';
import 'package:o7therapy/ui/screens/profile/widgets/custom_card.dart';
import 'package:o7therapy/ui/screens/profile/widgets/custom_rounded_button.dart';

import '../../../../_base/widgets/base_stateless_widget.dart';
import '../../../../api/models/auth/my_profile/my_profile_wrapper.dart';
import '../../../../res/const_colors.dart';
import '../../../../util/lang/app_localization_keys.dart';
import 'bottom_sheets/custom_buttom_sheet_update_contact_info.dart';
import 'bottom_sheets/custom_buttom_sheet_update_emergency_contact_info.dart';

class ContactInfoWidget extends BaseStatelessWidget {
  final MyProfileWrapper myProfileWrapper;
  ContactInfoWidget({Key? key, required this.myProfileWrapper})
      : super(key: key);
  @override
  Widget baseBuild(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 1 / 50 * height,
          ),
          Text(
            translate(LangKeys.personalContactInfo),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: ConstColors.app,
            ),
          ),
          SizedBox(
            height: 1 / 50 * height,
          ),
          SizedBox(
            width: width * 50,
            height: 0.24 * height,
            child: CustomCard(
              labels: [
                translate(LangKeys.phoneNumber),
                translate(LangKeys.primaryEmail),
                translate(LangKeys.secondaryEmail)
              ],
              values: [
                _getPhoneNumberValue(myProfileWrapper.data?.phoneNumber),
                (myProfileWrapper.data?.email == null ||
                        myProfileWrapper.data!.email!.isEmpty)
                    ? translate(LangKeys.noInformation)
                    : myProfileWrapper.data!.email!,
                (myProfileWrapper.data?.secondaryEmail == null ||
                        myProfileWrapper.data!.secondaryEmail!.isEmpty)
                    ? translate(LangKeys.noInformation)
                    : myProfileWrapper.data!.secondaryEmail!,
              ],
            ),
          ),
          SizedBox(
            height: 1 / 80 * height,
          ),
          CustomRoundedButton(
            text: translate(LangKeys.updateInfo),
            widthValue: width / 1.7,
            onPressed: () {
              String phoneNumber = myProfileWrapper.data?.phoneNumber ?? "";
              String primaryEmail = myProfileWrapper.data?.email ?? "";
              String secondaryEmail =
                  myProfileWrapper.data?.secondaryEmail ?? "";
              _openBottomSheetUpdateContactInfo(
                  context, phoneNumber, primaryEmail, secondaryEmail);
            },
          ),
          SizedBox(
            height: 1 / 50 * height,
          ),
          Text(
            translate(LangKeys.emergencyContact),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: ConstColors.app,
            ),
          ),
          SizedBox(
            height: 1 / 50 * height,
          ),
          SizedBox(
            width: width * 50,
            height: 0.31 * height,
            child: CustomCard(labels: [
              translate(LangKeys.name),
              translate(LangKeys.phoneNumber),
              translate(LangKeys.email),
              translate(LangKeys.relationship)
            ], values: [
              myProfileWrapper.data?.contactPersonName ??
                  translate(LangKeys.noInformation),
              _getPhoneNumberValue(
                  myProfileWrapper.data?.contactPersonPhoneNumber),
              (myProfileWrapper.data?.contactPersonEmail == null ||
                      myProfileWrapper.data!.contactPersonEmail!.isEmpty)
                  ? translate(LangKeys.noInformation)
                  : myProfileWrapper.data!.contactPersonEmail!,
              _getContactPersonRelationship(
                  relationship:
                      myProfileWrapper.data?.contactPersonRelationship ?? -1)
            ]),
          ),
          SizedBox(
            height: 1 / 60 * height,
          ),
          CustomRoundedButton(
            text: translate(LangKeys.updateInfo),
            widthValue: width / 1.7,
            onPressed: () {
              String contactPersonName =
                  myProfileWrapper.data?.contactPersonName ?? "";
              String contactPersonEmail =
                  myProfileWrapper.data?.contactPersonEmail ?? "";
              int contactPersonRelationship =
                  myProfileWrapper.data?.contactPersonRelationship ?? 8;
              String contactPersonPhoneNumber =
                  myProfileWrapper.data?.contactPersonPhoneNumber ?? "";

              _openBottomSheetUpdateEmergencyContactInfo(
                  context,
                  contactPersonName,
                  contactPersonPhoneNumber,
                  contactPersonEmail,
                  contactPersonRelationship);
            },
          ),
          SizedBox(
            height: 1 / 30 * height,
          ),
        ],
      ),
    );
  }

  String _getContactPersonRelationship({required int relationship}) {
    switch (relationship) {
      case (0):
        return translate(LangKeys.father);
        break;
      case (1):
        return translate(LangKeys.mother);
        break;
      case (2):
        return translate(LangKeys.brother);
        break;
      case (3):
        return translate(LangKeys.sister);
        break;
      case (4):
        return translate(LangKeys.son);
        break;
      case (5):
        return translate(LangKeys.daughter);
        break;
      case (6):
        return translate(LangKeys.relative);
        break;
      case (7):
        return translate(LangKeys.friend);
        break;
      case (8):
        return translate(LangKeys.other);
        break;
      default:
        return translate(LangKeys.noInformation);
    }
  }

  _openBottomSheetUpdateContactInfo(
      context, String phoneNumber, String primaryEmail, String secondaryEmail) {
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
        height: height - 400 + MediaQuery.of(context).viewInsets.bottom,
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: CustomBottomSheetUpdateContactInfo(
            phoneNumber: phoneNumber,
            primaryEmail: primaryEmail,
            secondaryEmail: secondaryEmail),
      ),
    );
  }

  _openBottomSheetUpdateEmergencyContactInfo(context, String name,
      String phoneNumber, String email, int relationship) {
    showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      )),
      builder: (BuildContext context) => Container(
        height: height - 300 + MediaQuery.of(context).viewInsets.bottom,
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: CustomBottomSheetUpdateEmergencyContactInfo(
          name: name,
          phoneNumber: phoneNumber,
          email: email,
          relationship: relationship,
        ),
      ),
    );
  }

  String _getPhoneNumberValue(String? value) {
    if (value == null || value.isEmpty) {
      return translate(LangKeys.noInformation);
    } else {
      String phoneNumber = "";
      String countryCode = "";

      if (value.contains('_')) {
        countryCode = value.substring(0, value.indexOf("_"));
        phoneNumber =
            "+$countryCode ${value.substring(value.indexOf("_") + 1, value.length)}";
      } else {
        phoneNumber = value;
      }
      return phoneNumber;
    }
  }
}
