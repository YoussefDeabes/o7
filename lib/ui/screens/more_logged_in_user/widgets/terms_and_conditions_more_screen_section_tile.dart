import 'package:flutter/material.dart';
import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/ui/screens/more_logged_in_user/widgets/more_screen_section_widget.dart';
import 'package:o7therapy/ui/screens/web_view/web_view_screen.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class TermsAndConditionsMoreScreenSectionTile extends StatelessWidget {
  const TermsAndConditionsMoreScreenSectionTile({super.key});

  @override
  Widget build(BuildContext context) {
    return MoreScreenSectionTile(
      title:
          AppLocalizations.of(context).translate(LangKeys.termsAndConditions),
      trailingIcon: false,
      onTap: () {
        Navigator.pushNamed(
          context,
          WebViewScreen.routeName,
          arguments: _getTermsAndConditionsUrl(context),
        );
      },
    );
  }

  String _getTermsAndConditionsUrl(BuildContext context) {
    if (AppLocalizations.of(context).locale.languageCode == 'ar') {
      return ApiKeys.arMobileTermsAndConditions;
    }
    return ApiKeys.mobileTermsAndConditions;
  }
}
