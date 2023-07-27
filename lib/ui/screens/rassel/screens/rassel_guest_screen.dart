import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/header_text_widget.dart';
import 'package:o7therapy/ui/screens/rassel/widgets/learn_more_text_button_rassel.dart';
import 'package:o7therapy/ui/screens/rassel/widgets/rassel_bullet_points_texts.dart';
import 'package:o7therapy/ui/screens/rassel/widgets/chat_with_a_wellness_supporter_text.dart';
import 'package:o7therapy/ui/screens/rassel/widgets/rassel_card_container.dart';
import 'package:o7therapy/ui/screens/rassel/widgets/reassel_banner.dart';
import 'package:o7therapy/ui/screens/rassel/widgets/two_colored_o7_rassel_text.dart';
import 'package:o7therapy/ui/widgets/shared_guest_widgets/start_now_button.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class RasselGuestScreen extends StatelessWidget {
  static const routeName = '/rassel-guest-screen';
  const RasselGuestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: HeaderWidget(text: context.translate(LangKeys.rassel)),
                ),
                RasselCardContainer(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const RasselBanner(),
                      const SizedBox(height: 12),
                      TwoColoredO7RasselText(),
                      const SizedBox(height: 4),
                      ChatWithAWellnessSupporterText(),
                      const SizedBox(height: 8),
                      _getMonthlySubscriptionText(context),
                      const SizedBox(height: 12),
                      RasselBulletPointsTexts(),
                      const SizedBox(height: 48),
                      const StartNowButton(),
                      LearnMoreTextButtonRassel(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text _getMonthlySubscriptionText(BuildContext context) {
    return Text(
      context.translate(LangKeys.monthlySubscriptionForGuest),
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: ConstColors.app,
        fontSize: 24,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
