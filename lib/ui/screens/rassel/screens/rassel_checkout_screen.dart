import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:adjust_sdk/adjust.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/api/adjust_manager.dart';
import 'package:o7therapy/api/mixpanel_manager.dart';
import 'package:o7therapy/api/models/calculate_subscription_send_model/calculate_subscription_send_model.dart';
import 'package:o7therapy/api/models/subscription_send_model/subscribe_send_model.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/rassel/bloc/checkout_bloc/rassel_checkout_bloc.dart';
import 'package:o7therapy/ui/screens/rassel/bloc/rassel_bloc/rassel_bloc.dart'
    as ra;
import 'package:o7therapy/ui/screens/rassel/screens/rassel_payment_screen.dart';
import 'package:o7therapy/ui/screens/rassel/screens/success_rassel_subscription.dart';
import 'package:o7therapy/ui/screens/rassel/widgets/rassel_policy.dart';
import 'package:o7therapy/ui/widgets/app_bar_more_screens/app_bar_more_screens.dart';
import 'package:o7therapy/ui/widgets/widgets.dart';
import 'package:o7therapy/util/general.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';

class RasselCheckoutScreen extends BaseScreenWidget {
  static const routeName = '/rassel-checkout-screen';

  const RasselCheckoutScreen({Key? key}) : super(key: key);

  @override
  BaseState screenCreateState() => _RasselCheckoutState();
}

class _RasselCheckoutState extends BaseScreenState<RasselCheckoutScreen>
    with WidgetsBindingObserver {
  late final Mixpanel _mixpanel;
  bool? fromReSubscribe = false;
  bool firstTimeResubscribeRassel=true;
  double originalRasselAmount=0.0;
  bool firstTime=true;
  String currency="";

  @override
  void initState() {
    // Track with event-name
    _initMixpanel();
    WidgetsBinding.instance.addObserver(this);
    AdjustManager.initPlatformState();
    super.initState();
    context.read<RasselCheckoutBloc>().add(RasselCheckoutInitEvt());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration.zero).then((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      setState(() {
        fromReSubscribe = args['fromReSubscribe'] ?? false;
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        Adjust.onResume();
        break;
      case AppLifecycleState.paused:
        Adjust.onPause();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBarForMoreScreens(
            title: translate(LangKeys.confirmYourSubscription),
          ),
          body: _getBody(),
        ),
      ),
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

  Widget _getBody() {
    return BlocConsumer<RasselCheckoutBloc, RasselCheckoutState>(
      listener: (context, state) async {
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
        if (state is SubscribeRasselSuccess) {
          if(fromReSubscribe!){
            // resubscribe corporate user
            _sendMixpanelSuccessfulResubscribeRasselEvent();
          }else{
            // subscribe first time individual user or corporate user
            _sendMixpanelSuccessfulSubscriptionFirstTimeEvent();
          }

          Navigator.of(context).pushReplacementNamed(
            SuccessRasselSubscriptionScreen.routeName,
          );
        }
        if (state is RasselCheckoutSubscribeState) {
       originalRasselAmount=   state.rasselSubscription.data!.originalAmount!;
       currency= _getCurrency(state.rasselSubscription.data!.currency!.toInt());
          context
              .read<RasselCheckoutBloc>()
              .add(RasselCalculateSubscriptionFeesEvt(
                  subscriptionId: state.rasselSubscription.data!.id,
                  subscribeSendModel: CalculateSubscriptionSendModel(
                    clientId: await PrefManager.getId(),
                    companyCode: await PrefManager.getCompanyCode(),
                    clientEmail: await PrefManager.getEmail(),
                    clientType: await PrefManager.isCorporate() ? 2 : 1,
                    serviceType: 4,
                    currency: state.rasselSubscription.data!.currency!.toInt(),
                    subscriptionId: state.rasselSubscription.data!.id!.toInt(),
                  )));
        }
      },
      builder: (context, state) {
        if (state is RasselCalculateSubscriptionFeesState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                _stepsSlide(state),
                _subscriptionDetailsHeader(),
                (state.calculateSubscriptionFees.data?.corpSubscribedRassel ??
                        false)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 9.0, horizontal: 8.0),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              appLocal.locale.languageCode == "ar"
                                  ? const TextSpan(text: "")
                                  : const TextSpan(
                                      text: "100% ",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                              TextSpan(
                                text: translate(LangKeys.discountWellnessPlan),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: ConstColors.text,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      )
                    : (fromReSubscribe!
                        ? const SizedBox.shrink()
                        : _subscriptionDescription(state)),
                _getDetailsCard(state),
                fromReSubscribe!
                    ? const SizedBox.shrink()
                    : state.calculateSubscriptionFees.data
                                ?.corpSubscribedRassel ??
                            false
                        ? const SizedBox()
                        : const RasselPolicy(),
                Expanded(child: Container()),
                _proceedToPayment(state),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _stepsSlide(RasselCalculateSubscriptionFeesState state) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0, bottom: 24),
      child: state.calculateSubscriptionFees.data?.corpSubscribedRassel ?? false
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                child: Container(
                    color: ConstColors.accentColor,
                    width: width / 1.5,
                    height: 3.5),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    child: Container(
                        color: ConstColors.accentColor,
                        width: width / 3,
                        height: 3.5),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    child: Container(
                        color: ConstColors.accentColor.withOpacity(0.5),
                        width: width / 3,
                        height: 3.5),
                  ),
                ),
              ],
            ),
    );
  }

//Header for what you will book for
  Widget _subscriptionDetailsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0),
      child: Text(
        translate(LangKeys.subscriptionDetails),
        style: const TextStyle(
            color: ConstColors.app, fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  //Description for trial
  Widget _subscriptionDescription(RasselCalculateSubscriptionFeesState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 8.0),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: translate(LangKeys.yourFreeTrialBeginsOn)),
            TextSpan(
              text: DateFormat('MMM d, y').format(DateTime.now().toLocal()),
              style: const TextStyle(
                  color: ConstColors.text,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
            TextSpan(text: translate(LangKeys.andWillEndOn)),
            TextSpan(
                text: DateFormat('MMM d, y').format(
                    DateTime.now().toLocal().add(const Duration(days: 31))),
                style: const TextStyle(
                    color: ConstColors.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
            const TextSpan(text: "."),
          ],
        ),
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: ConstColors.text, fontSize: 14, fontWeight: FontWeight.w400),
      ),
    );
  }

//Details card
  Widget _getDetailsCard(RasselCalculateSubscriptionFeesState state) {
    return SizedBox(
      width: width,
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              _subscriptionDetailsRow(state),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 17.0),
                child: lineDivider(),
              ),
              _chargedToday(state),
            ],
          ),
        ),
      ),
    );
  }

//Colored Text
  Widget _text(
      String text, FontWeight fontWeight, double fontSize, Color color) {
    return Text(
      text,
      style:
          TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color),
    );
  }

//Session & therapist info
  Widget _subscriptionDetailsRow(RasselCalculateSubscriptionFeesState state) {
    bool corpSubscribedRassel =
        state.calculateSubscriptionFees.data?.corpSubscribedRassel ?? false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _text(translate(LangKeys.o7Rassel), FontWeight.w600, 14,
                ConstColors.app),
            SizedBox(
              width: width / 3,
              child: RichText(
                text: TextSpan(
                  text: translate(LangKeys.monthlyPremium),
                  style: const TextStyle(
                      color: ConstColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            state.calculateSubscriptionFees.data?.corpSubscribedRassel ?? false
                ? const SizedBox()
                : (fromReSubscribe!
                    ? Text(
                        translate(LangKeys.oneMonthSubscription),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 12),
                      )
                    : const SizedBox()),
            const SizedBox(
              height: 4,
            ),
            state.calculateSubscriptionFees.data?.corpSubscribedRassel ?? false
                ? Text(
                    translate(LangKeys.oneMonthSubscription),
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 12),
                  )
                : (fromReSubscribe!
                    ? Text(
                        "${translate(LangKeys.from)} "
                        "${DateFormat('MMM d, y').format(DateTime.now().toLocal())} ${translate(LangKeys.to)} ${DateFormat('MMM d, y').format(DateTime.now().toLocal().add(const Duration(days: 31)))}",
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400))
                    : _text(translate(LangKeys.subscriptionPriceAfterFreeTrial),
                        FontWeight.w500, 12, ConstColors.text)),
          ],
        ),
        FittedBox(
          child: Column(
            children: [
              SvgPicture.asset(
                AssPath.rasselBanner,
                height: width * 0.2,
                width: width * 0.2,
              ),
              const SizedBox(height: 16),
              BlocBuilder<ra.RasselBloc, ra.RasselState>(
                  builder: (context, state) {
                String? originalAmount = ra.RasselBloc.rasselSubscriptionState
                    ?.rasselSubscription.data?.originalAmount
                    ?.toInt()
                    .toString();
                String currency = getRasselCurrency(
                  context,
                  ra.RasselBloc.rasselSubscriptionState?.rasselSubscription.data
                          ?.currency ??
                      0,
                );
                return _text(
                    "${corpSubscribedRassel ? "0" : originalAmount ?? ""} $currency",
                    FontWeight.w600,
                    16,
                    ConstColors.accentColor);
              }),
            ],
          ),
        ),
      ],
    );
  }

//Subscription fees row
  Widget _chargedToday(RasselCalculateSubscriptionFeesState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _text(
            fromReSubscribe!
                ? translate(LangKeys.total)
                : translate(LangKeys.chargedToday),
            FontWeight.w600,
            14,
            ConstColors.app),
        _text(
            fromReSubscribe!
                ? "${state.calculateSubscriptionFees.data!.subscriptionFees!.toInt().toString()} ${getCurrencyNameByContext(context, state.calculateSubscriptionFees.data!.currency!)}"
                : "${state.calculateSubscriptionFees.data!.subscriptionFees!.toInt().toString()} ${getCurrencyNameByContext(context, state.calculateSubscriptionFees.data!.currency!)}",
            FontWeight.w600,
            16,
            ConstColors.text),
      ],
    );
  }

  Widget _proceedToPayment(RasselCalculateSubscriptionFeesState state) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(
          top: 20.0, left: width / 10, right: width / 10, bottom: 20),
      child: SizedBox(
        width: width,
        height: 45,
        child: ElevatedButton(
          onPressed: () async {
           await _onButtonClicked(state);
     },
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ))),
          child: Text(translate(
            state.calculateSubscriptionFees.data?.corpSubscribedRassel ?? false
                ? LangKeys.confirmSubscription
                : fromReSubscribe!
                    ? LangKeys.proceedToPayment
                    : LangKeys.subscribeNow,
          )),
        ),
      ),
    );
  }

///////////////////////////////////////////////////////////
/////////////////// Helper methods ////////////////////////
///////////////////////////////////////////////////////////

  FutureOr _onGoBack(dynamic value) {
    context.read<RasselCheckoutBloc>().add(RasselCheckoutInitEvt());
  }

  DateTime _getDate(String date) {
    String year = date.substring(0, 4);
    String month = date.substring(4, 6);
    String day = date.substring(6, 8);
    String hour = date.substring(8, 10);
    String minute = date.substring(10, 12);
    String second = date.substring(12, 14);
    String formattedDate = "$year-$month-${day}T$hour:$minute:${second}Z";
    return DateTime.parse(formattedDate);
  }

  Future<void> _initMixpanel() async {
    _mixpanel = await MixpanelManager.init();
  }

  String _getCurrency(num currency) {
    switch (currency) {
      case 1:
        return translate(LangKeys.egp);
      case 2:
        return translate(LangKeys.usd);
      case 5:
        return translate(LangKeys.kwd);
      default:
        return translate(LangKeys.egp);
    }
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
  _onButtonClicked(state)async{
    int clientType = 1;
    bool isCorporate = await PrefManager.isCorporate();
    if (isCorporate) {
      clientType = 2;
    } else {
      clientType = 1;
    }

    _mixpanel.track("Subscribe now",properties:
    {"Client type":clientType==2?"corporate":"individual",
      "Rassel Currency":state.calculateSubscriptionFees.data!.currency!,
      "Company Name":await PrefManager.getCorporateName(),
      "Rassel price(Original Price)":originalRasselAmount
    });

    if (state.calculateSubscriptionFees.data!.subscriptionFees == 0 &&
        clientType == 2 &&
        state.calculateSubscriptionFees.data!.corpSubscribedRassel!) {
      context.read<RasselCheckoutBloc>().add(PayNowRasselSubscribeEvent(
        clientSubscriptionId: state
            .calculateSubscriptionFees.data!.subscriptionId!
            .toInt(),
        currency: _getCurrencyNum(
            state.calculateSubscriptionFees.data!.currency!)
            .toInt(),
        clientType: clientType,
      ));
    } else {
      Navigator.of(context)
          .pushNamed(RasselPaymentScreen.routeName, arguments: {
        "amount":
        state.calculateSubscriptionFees.data!.subscriptionFees,
        "originalRasselAmount":
        originalRasselAmount,
        "currency": _getCurrencyNum(
            state.calculateSubscriptionFees.data!.currency!),
        "id": state.calculateSubscriptionFees.data!.subscriptionId,
        "fromReSubscribe": fromReSubscribe
      }).then(_onGoBack);
    }

  }
  _sendMixpanelSuccessfulSubscriptionFirstTimeEvent()async{
    if(firstTime) {
      _mixpanel.track(
          "Successful Subscription first time", properties: {
        "Rassel Currency": currency,
        "Rassel price(original Price)": originalRasselAmount,
        "Corporate Name": await PrefManager
            .getCorporateName(),
        "Client type": await PrefManager.isCorporate()
            ? "corporate"
            : "individual",
        "Subscription start date": DateFormat('MMM d, y')
            .format(DateTime.now().toLocal()),
        "Subscription End date": DateFormat('MMM d, y')
            .format(
            DateTime.now().toLocal().add(
                const Duration(days: 31)))
      });
      setState(() {
        firstTime=false;
      });
    }
  }
  _sendMixpanelSuccessfulResubscribeRasselEvent()async{
    if(firstTimeResubscribeRassel) {
      _mixpanel.track(
          "successful Resubscribe", properties: {
        "Rassel Currency": currency,
        "Rassel price": originalRasselAmount,
        "Corporate Name": await PrefManager
            .getCorporateName(),
        "Client type": await PrefManager.isCorporate()
            ? "corporate"
            : "individual",
      });
      setState(() {
        firstTimeResubscribeRassel=false;
      });
    }
  }
}
