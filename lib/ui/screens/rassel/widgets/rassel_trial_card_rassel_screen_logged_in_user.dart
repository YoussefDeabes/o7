import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/ui/screens/rassel/widgets/chat_with_a_wellness_supporter_text.dart';
import 'package:o7therapy/ui/screens/rassel/widgets/learn_more_text_button_rassel.dart';
import 'package:o7therapy/ui/screens/rassel/widgets/one_month_free_trial_button.dart';
import 'package:o7therapy/ui/screens/rassel/widgets/rassel_bullet_points_texts.dart';
import 'package:o7therapy/ui/screens/rassel/widgets/rassel_card_container.dart';
import 'package:o7therapy/ui/screens/rassel/widgets/rassel_price.dart';
import 'package:o7therapy/ui/screens/rassel/widgets/reassel_banner.dart';
import 'package:o7therapy/ui/screens/rassel/widgets/two_colored_o7_rassel_text.dart';

class RasselTrialCardRasselScreenLoggedInUser extends StatelessWidget {
  final double originalRasselAmount;
  final num currency;
   RasselTrialCardRasselScreenLoggedInUser({super.key,required this.currency,required this.originalRasselAmount});

  @override
  Widget build(BuildContext context) {
    return RasselCardContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const RasselBanner(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TwoColoredO7RasselText(),
                ChatWithAWellnessSupporterText(),
                const RasselPrice(),
                RasselBulletPointsTexts(),
                oneMonthFreeTrialButton(originalRasselAmount: originalRasselAmount,currency: currency,),
                LearnMoreTextButtonRassel(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
