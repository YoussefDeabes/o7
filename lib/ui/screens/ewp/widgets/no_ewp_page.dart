import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/web_view/web_view_screen.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class NoEwpPage extends StatelessWidget {
  const NoEwpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  foregroundImage: const AssetImage(AssPath.activityBanner),
                  backgroundColor: ConstColors.appWhite,
                  radius: context.width / 3.5,
                ),
                SizedBox(height: 0.03 * context.height),
                SizedBox(
                  width: context.width * 0.7,
                  child: Text(
                    context
                        .translate(LangKeys.youDoNotHaveEmployeesWellnessPlan),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: ConstColors.text,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            width: context.width * 0.8,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: ConstColors.text,
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: "${context.translate(LangKeys.youCanFill)} ",
                  ),
                  TextSpan(
                      text: context.translate(LangKeys.thisForm),
                      style: const TextStyle(
                        color: ConstColors.secondary,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _navigateToFrom(context)),
                  TextSpan(
                    text:
                        " ${context.translate(LangKeys.withYourCompanyDetailsAndWeWillGetInTouch)}",
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 0.07 * context.height),
        ],
      ),
    );
  }

  _navigateToFrom(BuildContext context) async {
    // Navigate to the Form to fill NO Wellness Plan
    const String corporateRegistrationUrl = ApiKeys.ewpFormUrl;
    final Uri corporateRegistrationUri = Uri.parse(corporateRegistrationUrl);

    canLaunchUrl(corporateRegistrationUri).then((canLaunch) {
      if (canLaunch) {
        Navigator.pushNamed(
          context,
          WebViewScreen.routeName,
          arguments: corporateRegistrationUrl,
        );
      } else {
        showToast('Oops.. Could not launch link!');
      }
    });
  }
}
