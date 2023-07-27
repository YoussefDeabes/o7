import 'package:flutter/material.dart';
import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/ui/screens/more_logged_in_user/widgets/more_screen_section_widget.dart';
import 'package:o7therapy/ui/screens/web_view/web_view_screen.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class AboutO7TherapyMoreScreenSectionTile extends StatelessWidget {
  const AboutO7TherapyMoreScreenSectionTile({super.key});

  @override
  Widget build(BuildContext context) {
    return MoreScreenSectionTile(
      title: AppLocalizations.of(context).translate(LangKeys.aboutO7Therapy),
      trailingIcon: false,
      onTap: () {
        Navigator.pushNamed(
          context,
          WebViewScreen.routeName,
          arguments: _getArgumentsString(context),
        );
      },
    );
  }

  String _getArgumentsString(BuildContext context) {
    if (AppLocalizations.of(context).locale.languageCode == 'ar') {
      return ApiKeys.arAboutO7;
    }
    return ApiKeys.aboutO7;
  }
}
