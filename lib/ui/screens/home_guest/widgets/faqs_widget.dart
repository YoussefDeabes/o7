import 'package:expandable/expandable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/home/home_main/home_main_screen.dart';
import 'package:o7therapy/ui/screens/home/home_main_logged_in/home_main_logged_in/home_main_logged_in_screen.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/header_text_widget.dart';
import 'package:o7therapy/ui/screens/web_view/web_view_screen.dart';
import 'package:o7therapy/ui/widgets/widgets.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

const List<String> faqs = [
  LangKeys.whatIsO7Therapy,
  LangKeys.howCanOnlineTherapyImproveMyLife,
  LangKeys.whoAreTheTherapists,
  LangKeys.howAreTheTherapistsVerified,
  LangKeys.howAmIBilled,
  LangKeys.howDoYouProtectMyPrivacy,
];

class FaqsWidget extends StatelessWidget {
  final bool fromGuestScreen;
  const FaqsWidget({Key? key, required this.fromGuestScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: HeaderWidget(
            text: context.translate(LangKeys.faqs),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          primary: false,
          itemCount: 6,
          separatorBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: lineDivider(height: 1.5),
          ),
          itemBuilder: (context, index) => ExpandableNotifier(
            child: ScrollOnExpand(
              child: ExpandablePanel(
                header: Text(
                  '${index + 1}. ${context.translate(faqs[index])}',
                  style: const TextStyle(
                    color: ConstColors.app,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                collapsed: const SizedBox.shrink(),
                expanded: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _answersText(index, context),
                ),
                // tapHeaderToExpand: true,
                // hasIcon: true,
                theme: const ExpandableThemeData(
                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                    alignment: Alignment.center,
                    iconColor: ConstColors.app,
                    tapBodyToCollapse: true,
                    tapBodyToExpand: true),
              ),
            ),
          ),
        ),
      ],
    );
  }

  //Cancellation policy
  Widget _answersText(int index, BuildContext context) {
    switch (index) {
      case 0:
        return Text.rich(
             TextSpan(
          style: const TextStyle(fontSize: 12, color: ConstColors.text),
          children: <TextSpan>[
            TextSpan(
                text: context.translate(LangKeys.whatIsO7Faq1),
                style: const TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ConstColors.text)),
            TextSpan(
                text:
                    '\n\n${context.translate(LangKeys.forMoreInformationPleaseCheckThe)} ',
                style: const TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ConstColors.text)),
            TextSpan(
              text: context.translate(LangKeys.aboutUs),
              style: const TextStyle(
                  height: 1.5,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: ConstColors.secondary,
                  decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()
                ..onTap = () => Navigator.pushNamed(
                    context, WebViewScreen.routeName,
                    arguments: "https://o7therapy.com/mobile-about-o7/"),
            )
          ],
        ));
      case 1:
        return Text.rich(
            TextSpan(
          style: const TextStyle(fontSize: 12, color: ConstColors.text),
          children: <TextSpan>[
            TextSpan(
                text:
                    context.translate(LangKeys.howCanTherapyImproveMyLifeFaq1),
                style: const TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ConstColors.text)),
            TextSpan(
                text:
                    '\n\n${context.translate(LangKeys.howCanTherapyImproveMyLifeFaq2)}',
                style: const TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ConstColors.text)),
          ],
        ));
      case 2:
        return Text.rich(
             TextSpan(
          style: const TextStyle(fontSize: 12, color: ConstColors.text),
          children: <TextSpan>[
            TextSpan(
                text: context.translate(LangKeys.whoIsTherapistsFaq1),
                style: const TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ConstColors.text)),
            TextSpan(
                text: context.translate(LangKeys.whoIsTherapistsFaq2),
                style: const TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ConstColors.secondary,
                    decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    /// this will navigate the user to home main that contains app bar and bottom bar
                    /// but with index 1 === is the booking screen
                    if (fromGuestScreen) {
                      Navigator.of(context).pushReplacementNamed(
                          HomeMainScreen.routeName,
                          arguments: 2);
                    } else {
                      Navigator.of(context).pushReplacementNamed(
                          HomeMainLoggedInScreen.routeName,
                          arguments: HomeMainLoggedInPages.bookingScreen);
                    }
                  }),
            TextSpan(
                text: context.translate(LangKeys.whoIsTherapistsFaq3),
                style: const TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ConstColors.text)),
          ],
        ));
      case 3:
        return Text.rich(
           TextSpan(
          style: const TextStyle(fontSize: 12, color: ConstColors.text),
          children: <TextSpan>[
            TextSpan(
                text: context.translate(LangKeys.howAreTherapistsVerifiedFaq1),
                style: const TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ConstColors.text)),
            TextSpan(
                text:
                    "\n${context.translate(LangKeys.howAreTherapistsVerifiedFaq2)}",
                style: const TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ConstColors.text)),
            TextSpan(
                text:
                    "\n${context.translate(LangKeys.howAreTherapistsVerifiedFaq3)}",
                style: const TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ConstColors.text)),
          ],
        ));
      case 4:
        return Text.rich(
             TextSpan(
          style: const TextStyle(fontSize: 12, color: ConstColors.text),
          children: <TextSpan>[
            TextSpan(
                text: context.translate(LangKeys.howAmIBilledFaq),
                style: const TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ConstColors.text)),
          ],
        ));
      case 5:
        return Text.rich(
             TextSpan(
          style: const TextStyle(fontSize: 12, color: ConstColors.text),
          children: <TextSpan>[
            TextSpan(
                text: context.translate(LangKeys.privacyFaq1),
                style: const TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ConstColors.text)),
            TextSpan(
                text: context.translate(LangKeys.privacyFaq2),
                style: const TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ConstColors.text,
                    decoration: TextDecoration.underline)),
            TextSpan(
                text: context.translate(LangKeys.privacyFaq3),
                style: const TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ConstColors.text)),
            TextSpan(
                text: context.translate(LangKeys.privacyFaq4),
                style: const TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ConstColors.secondary,
                    decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => Navigator.pushNamed(
                      context, WebViewScreen.routeName,
                      arguments:
                          "https://o7therapy.com/mobile-privacy-policy/")),
            TextSpan(
                text: "\n\n${context.translate(LangKeys.privacyFaq5)}",
                style: const TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ConstColors.text)),
            TextSpan(
                text: context.translate(LangKeys.privacyFaq6),
                style: const TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ConstColors.text,
                    decoration: TextDecoration.underline)),
            TextSpan(
                text: "\n${context.translate(LangKeys.privacyFaq7)}",
                style: const TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ConstColors.text)),
            TextSpan(
                text: "\n${context.translate(LangKeys.privacyFaq8)}",
                style: const TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ConstColors.text)),
            TextSpan(
                text: "\n${context.translate(LangKeys.privacyFaq9)}",
                style: const TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ConstColors.text)),
            TextSpan(
                text: context.translate(LangKeys.privacyFaq10),
                style: const TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: ConstColors.text)),
            TextSpan(
                text: "${context.translate(LangKeys.privacyFaq11)} ",
                style: const TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ConstColors.text)),
            TextSpan(
                text: "${context.translate(LangKeys.privacyFaq12)} ",
                style: const TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: ConstColors.text)),
            TextSpan(
                text: context.translate(LangKeys.privacyFaq13),
                style: const TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ConstColors.text)),
            TextSpan(
                text: context.translate(LangKeys.privacyFaq14),
                style: const TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ConstColors.secondary,
                    decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => Navigator.pushNamed(
                      context, WebViewScreen.routeName,
                      arguments: "https://www.hhs.gov/hipaa/index.html")),
          ],
        ));
      default:
        return const Text("");
    }
  }
}
