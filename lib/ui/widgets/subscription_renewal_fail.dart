import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/api/models/rassel_subscription/RasselSubscription.dart';
import 'package:o7therapy/bloc/lang/language_cubit.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/profile/widgets/custom_rounded_button.dart';
import 'package:o7therapy/ui/screens/rassel/screens/rassel_payment_screen.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/lang/app_language.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

import '../screens/home/home_main_logged_in/home_main_logged_in/home_main_logged_in_screen.dart';

class SubscriptionRenewalFail extends BaseScreenWidget {
  final bool showGoHome;
  final RasselSubscription subscription;

  const SubscriptionRenewalFail(
      {Key? key, required this.showGoHome, required this.subscription})
      : super(key: key);

  @override
  BaseState screenCreateState() => _CancelSubscriptionWidgetState();
}

class _CancelSubscriptionWidgetState
    extends BaseScreenState<SubscriptionRenewalFail> {
  @override
  Widget buildScreenWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            translate(LangKeys.subscriptionRenewalFail),
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: ConstColors.app),
            textAlign: TextAlign.center,
          ),
        const  SizedBox(
            height:10,
          ),
          SizedBox(
            height:LanguageCubit().state.languageCode=="en"? 80:60,
            child: Text(
              translate(LangKeys.renewalFailedSuspendedAccUpdatePayment),
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: ConstColors.text),
              textAlign: TextAlign.center,
            ),
          ),
         const SizedBox(
            height:10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // CustomRoundedButton(
              //     isLight: true,
              //     onPressed: () {
              //       widget.onLaterClicked();
              //        },
              //     fontsize: 12,
              //     text: translate(LangKeys.later),
              //     widthValue: width * 0.24),
              // const  SizedBox(width: 8,),
              CustomRoundedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RasselPaymentScreen.routeName,
                        arguments: {
                      "originalRasselAmount":widget.subscription.data!.originalAmount??0,
                          "amount": widget.subscription.data?.amount,
                          "currency":
                              widget.subscription.data?.currency!.toInt(),
                          "id": widget.subscription.data?.id,
                          "fromReSubscribe": true
                        });
                  },
                  text: translate(LangKeys.updatePayment),
                  fontsize: 14,
                  widthValue: width * 0.5),
            ],
          ),
         const SizedBox(
            height:20,
          ),
          widget.showGoHome
              ? InkWell(
                  onTap: () async {
                    Navigator.pushReplacementNamed(
                        context, HomeMainLoggedInScreen.routeName);
                  },
                  child: Text(translate(LangKeys.goHome),
                      style: const TextStyle(
                          color: ConstColors.secondary,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                          fontSize: 14)))
              : const SizedBox()
        ],
      ),
    );
  }

  num _getCurrencyNum(String currency) {
    switch (currency) {
      case 'EGP':
        return 1;
      case 'USD':
        return 2;
      case 'KWD':
        return 5;
      default:
        return 1;
    }
  }
}
