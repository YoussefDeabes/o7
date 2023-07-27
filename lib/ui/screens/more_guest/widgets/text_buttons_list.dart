import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/ui/screens/rassel/screens/rassel_screen.dart';
import 'package:o7therapy/ui/screens/more_guest/widgets/choose_language_widget.dart';
import 'package:o7therapy/ui/screens/more_logged_in_user/widgets/about_o7_therapy_more_screen_section_tile.dart';
import 'package:o7therapy/ui/screens/more_logged_in_user/widgets/faqs_more_screen_section_tile.dart';
import 'package:o7therapy/ui/screens/more_guest/widgets/choose_language_widget.dart';
import 'package:o7therapy/ui/screens/more_logged_in_user/widgets/about_o7_therapy_more_screen_section_tile.dart';
import 'package:o7therapy/ui/screens/more_logged_in_user/widgets/faqs_more_screen_section_tile.dart';
import 'package:o7therapy/ui/screens/rassel/screens/rassel_screen.dart';
import 'package:o7therapy/ui/screens/more_logged_in_user/widgets/more_screen_section_widget.dart';
import 'package:o7therapy/ui/screens/more_logged_in_user/widgets/privacy_policy_more_screen_section_tile.dart';
import 'package:o7therapy/ui/screens/more_logged_in_user/widgets/terms_and_conditions_more_screen_section_tile.dart';
import 'package:o7therapy/ui/screens/web_view/web_view_screen.dart';
import 'package:o7therapy/ui/widgets/contact_us/contact_us_mixin.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

/// the enum of textButtons
enum TextButtonsNames {
  aboutO7Therapy,
  faqs,
  contactUs,
  privacyPolicy,
  termsAndConditions,
  changeLanguage,
}

// ignore: must_be_immutable
class TextButtonsList extends BaseStatelessWidget with ContactUsMixin {
  TextButtonsList({Key? key}) : super(key: key);

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      children: [
        const AboutO7TherapyMoreScreenSectionTile(),
        const FaqsMoreScreenSectionTile(),
        MoreScreenSectionTile(
          title: translate(LangKeys.contactUs),
          trailingIcon: false,
          onTap: () {
            getContactUsOnPressed(context);
          },
        ),

        const PrivacyPolicyMoreScreenSectionTile(),
        const TermsAndConditionsMoreScreenSectionTile(),
        // MoreScreenSectionTile(
        //   title: translate(LangKeys.changeLanguage),
        //   onTap: () {},
        // ),
        ChooseLanguageWidget(),
      ],
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

}
