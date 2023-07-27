import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/rassel/widgets/chat_with_a_wellness_supporter_text.dart';
import 'package:o7therapy/ui/screens/rassel/widgets/rassel_card_container.dart';
import 'package:o7therapy/ui/screens/rassel/widgets/rassel_price.dart';
import 'package:o7therapy/ui/screens/rassel/widgets/reassel_banner.dart';
import 'package:o7therapy/ui/screens/rassel/widgets/two_colored_o7_rassel_text.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

import '../../home_logged_in/bloc/rassel_card_bloc/rassel_card_bloc.dart';
import 'learn_more_text_button_rassel.dart';
import 'one_month_free_trial_button.dart';
import 'rassel_bullet_points_texts.dart';

class RasselTrialCardHomeScreenLoggedInUserCard extends StatelessWidget {
  final double originalRasselAmount;
  final num currency;
  const RasselTrialCardHomeScreenLoggedInUserCard({Key? key,required this.originalRasselAmount,required this.currency})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String Function(String key) translate =
        AppLocalizations.of(context).translate;
    return RasselCardContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: AlignmentDirectional.centerEnd,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextButton(
              onPressed: () {
                RasselCardBloc.bloc(context)
                    .add(const DismissRasselCardEvent());
              },
              child: Text(
                translate(LangKeys.dismiss),
                style: const TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: ConstColors.secondary),
              ),
            ),
          ),
          const RasselBanner(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TwoColoredO7RasselText(),
                ChatWithAWellnessSupporterText(),
                const RasselPrice(),
                RasselBulletPointsTexts(),
                oneMonthFreeTrialButton(originalRasselAmount:originalRasselAmount,currency:currency),
                LearnMoreTextButtonRassel(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
