import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/api/mixpanel_manager.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/profile/widgets/custom_rounded_button.dart';
import 'package:o7therapy/ui/screens/rassel/bloc/rassel_bloc/rassel_bloc.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';

class CancelSubscriptionWidget extends BaseScreenWidget {
  String id;
  String currency;
  String nextPaymentDate;
  num paidFees;

  CancelSubscriptionWidget(
      {Key? key,
      required this.id,
      required this.currency,
      required this.paidFees,
      required this.nextPaymentDate})
      : super(key: key);

  @override
  BaseState screenCreateState() => _CancelSubscriptionWidgetState();
}

class _CancelSubscriptionWidgetState
    extends BaseScreenState<CancelSubscriptionWidget> {
  late final Mixpanel _mixpanel;
  bool firstTime = true;

  @override
  void initState() {
    super.initState();
    _initMixpanel();
  }

  Future<void> _initMixpanel() async {
    _mixpanel = await MixpanelManager.init();
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
    return BlocConsumer<RasselBloc, RasselState>(
      listener: (context, state) {
        if (state is RasselLoadingState) {
          showLoading();
        } else {
          hideLoading();
        }

        if (state is NetworkError) {
          if (state.message == "Session expired") {
            clearData();
            Navigator.of(context).pushNamedAndRemoveUntil(
                LoginScreen.routeName, (Route<dynamic> route) => false);
          }
          showToast(state.message);
        }
        if (state is ErrorState) {
          if (state.message == "Session expired") {
            clearData();
            Navigator.of(context).pushNamedAndRemoveUntil(
                LoginScreen.routeName, (Route<dynamic> route) => false);
          }
          showToast(state.message);
        }
        if (state is RasselCancelSubscriptionState) {
          _sendMixpanelSuccessfulCancelEvent();
          Navigator.pop(context);
          // call to update on chache "has active subscription"
          context.read<RasselBloc>().add(RasselInitialEvt());
        }
      },
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.only(right: 16, left: 16, top: 16),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                translate(LangKeys.cancelSubscription),
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: ConstColors.app),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                translate(LangKeys.unSubscripeRassel),
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: ConstColors.text),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomRoundedButton(
                      isLight: true,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      text: translate(LangKeys.back),
                      widthValue: width * 0.35),
                  const SizedBox(
                    width: 20,
                  ),
                  CustomRoundedButton(
                      onPressed: () {
                        context.read<RasselBloc>().add(
                            RasselCancelSubscriptionEvt(
                                clientSubscriptionId: widget.id));
                      },
                      text: translate(LangKeys.yesUnSubscripe),
                      widthValue: width * 0.5),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  _sendMixpanelSuccessfulCancelEvent() async {
    if (firstTime) {
      _mixpanel.track("Successful Cancel Subscription", properties: {
        "Corporate Name": await PrefManager.getCorporateName(),
        "Client type":
            await PrefManager.isCorporate() ? "corporate" : "individual",
        "Rassel Currency": widget.currency,
        "Rassel price": widget.paidFees,
        "Subscription start date": DateTime.parse(widget.nextPaymentDate)
            .subtract(const Duration(days: 30)),
        "Subscription End date": widget.nextPaymentDate
      });
      setState(() {
        firstTime = false;
      });
    }
  }
}
