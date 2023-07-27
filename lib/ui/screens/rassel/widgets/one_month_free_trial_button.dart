import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/ui/screens/rassel/bloc/rassel_bloc/rassel_bloc.dart';
import 'package:o7therapy/ui/screens/rassel/screens/rassel_checkout_screen.dart';
import 'package:o7therapy/util/general.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/api/mixpanel_manager.dart';

class oneMonthFreeTrialButton extends BaseStatelessWidget {
  final double originalRasselAmount;
  final num currency;
  oneMonthFreeTrialButton({super.key,required this.originalRasselAmount,required this.currency});
  @override
  Widget baseBuild(BuildContext context) {
    return BlocBuilder<RasselBloc, RasselState>(
      buildWhen: (previous, current) => current is RasselSubscriptionState,
      builder: (context, state) {
        bool isSupscripedBefore = RasselBloc.rasselSubscriptionState
                ?.rasselSubscription.data?.isSupscripedBefore ??
            false;

        String text = isSupscripedBefore
            ? translate(LangKeys.reSubscribeNow)
            : translate(LangKeys.oneMonthFreeTrial);

        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(
              top: height / 50,
              left: width / 15,
              right: width / 15,
              bottom: height / 50),
          child: SizedBox(
            width: width,
            height: 45,
            child: ElevatedButton(
              onPressed: () async{
                if(!isSupscripedBefore) {
                  final Mixpanel _mixpanel = await MixpanelManager.init();
                  _mixpanel.track("Start free trial", properties: {
                    "client type": await PrefManager.isCorporate()
                        ? "corporate"
                        : "individual",
                    "Corporate Name": await PrefManager.getCorporateName(),
                    "Rassel price(Original Price)": originalRasselAmount,
                    "Rassel Currency": getRasselCurrency(context, currency),
                  });
                }
                Navigator.of(context)
                    .pushNamed(RasselCheckoutScreen.routeName, arguments: {
                  "fromReSubscribe": isSupscripedBefore,
                });
              },
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ))),
              child: Text(text),
            ),
          ),
        );
      },
    );
  }
}
