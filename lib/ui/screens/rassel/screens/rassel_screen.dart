import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:freshchat_sdk/freshchat_user.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/api/mixpanel_manager.dart';
import 'package:o7therapy/bloc/lang/language_cubit.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/home/home_main_logged_in/home_main_logged_in/home_main_logged_in_screen.dart';
import 'package:o7therapy/ui/screens/rassel/bloc/rassel_bloc/rassel_bloc.dart';
import 'package:o7therapy/ui/screens/rassel/model/rassel_user_state.dart';
import 'package:o7therapy/ui/screens/rassel/screens/rassel_checkout_screen.dart';
import 'package:o7therapy/ui/screens/rassel/widgets/rassel_trial_card_rassel_screen_logged_in_user.dart';

import 'package:o7therapy/ui/widgets/subscription_renewal_fail.dart';
import 'package:o7therapy/ui/screens/rassel/widgets/reassel_banner.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';
import 'package:o7therapy/api/models/rassel_subscription/RasselSubscription.dart';

class RasselScreen extends BaseStatefulWidget {
  static const routeName = '/rassel-screen';

  const RasselScreen({Key? key}) : super(key: key);

  @override
  BaseState<RasselScreen> baseCreateState() => _RasselScreenState();
}

class _RasselScreenState extends BaseState<RasselScreen>
    with WidgetsBindingObserver {
  // int _counter = 0;
  final GlobalKey<ScaffoldState>? _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool rasselScreen = true;
  bool? hasActiveSubscription;
  bool? isSubscribedBefore;
  ValueNotifier<String?> notificationMessage = ValueNotifier(null);
  ValueNotifier<int> notificationCount = ValueNotifier(0);
  ValueNotifier<bool> _isIncrementCounterPressed = ValueNotifier(false);
  bool _isFreshChatEnabled = false;

  String? userName;
  String? expirationDate;
  int? subscriptionStatus;
  bool? userCanceledSubscription;
  Stream<dynamic>? _unreadCountStream;
  StreamSubscription<dynamic>? _onMessageCountUpdate;
  StreamSubscription<RemoteMessage>? _onMessageListener;
  RasselSubscription? subscription;
  double originalRasselAmount = 0.0;
  num currency = 0;
  late final Mixpanel _mixpanel;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
      case AppLifecycleState.detached:
        RasselUserState.isConversationOpened = false;
        _isIncrementCounterPressed.value = false;
        debugPrint(
          "app is in resumed state"
          "Or app has been removed(detached State)",
        );
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        if (_isIncrementCounterPressed.value) {
          RasselUserState.isConversationOpened = true;
        }

        debugPrint("app is in inactive state Or paused state");
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    RasselUserState.isConversationOpened = false;
    context.read<RasselBloc>().add(RasselInitialEvt());
    WidgetsBinding.instance.addObserver(this);
    rasselScreen = true;
    _initMixpanel();
  }

  Future<void> _initMixpanel() async {
    _mixpanel = await MixpanelManager.init();
  }

  void _incrementCounter() async {
    _mixpanel.track("Show conversation Action");
    try {
      notificationCount.value = 0;
      Freshchat.showConversations();
      _isIncrementCounterPressed.value = true;
    } catch (_) {}
  }

  @override
  void didChangeDependencies() {
    RasselUserState.isConversationOpened = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    RasselUserState.isConversationOpened = false;
    WidgetsBinding.instance.removeObserver(this);
    _onMessageCountUpdate?.cancel();

    _onMessageListener?.cancel();
    _onMessageCountUpdate = null;
    _unreadCountStream = null;
    _onMessageListener = null;
    super.dispose();
  }

  /// TODO : Need to remove this method
  /// TODO : remove FirebaseMessaging.onMessage and use the one in the onForeground msg
  _enableFreshChatForSubscribedUserOnly() async {
    if (_isFreshChatEnabled) {
      return;
    }
    _isFreshChatEnabled = true;
    _onMessageListener ??=
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      var data = message.data;
      notificationMessage.value = data['body'];
      notificationCount.value = (notificationCount.value) + 1;
      userName = data['user_name'];
      log("Notification Content: $data");
    });
    _getUnreadMessagesCount();
  }

  @override
  Widget baseBuild(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _getBody(),
    );
  }

  Widget _getBody() {
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
        if (state is RasselSubscriptionState && rasselScreen) {
          currency = state.rasselSubscription.data!.currency!;
          originalRasselAmount = state.rasselSubscription.data!.originalAmount!;
          setState(() {
            subscription = state.rasselSubscription;
            expirationDate = state.rasselSubscription.data?.expirationDate;
            subscriptionStatus =
                state.rasselSubscription.data?.subscriptionStatus;
            // user canceled subscription will return 3 from backend
            userCanceledSubscription = subscriptionStatus == 3 ? true : false;
            hasActiveSubscription =
                state.rasselSubscription.data?.hasActiveSubscription;
            isSubscribedBefore =
                state.rasselSubscription.data?.isSupscripedBefore;
          });
          // context.read<RasselBloc>().add(RasselIsSubscribedEvt(
          //     subscriptionId: state.rasselSubscription.data!.id.toString(),
          //     amount: state.rasselSubscription.data!.amount!,
          //     currency: state.rasselSubscription.data!.currency!));
          rasselScreen = false;
        }
        // if (state is RasselSubscribedState) {
        //   context.read<RasselBloc>().add(RasselClientSubscriptionsEvt());
        // }
        // if (state is RasselClientSubscriptionState) {
        //   nextPaymentDateTime = DateTime.parse(
        //       state.rasselClientSubscriptions!.data!.nextPaymentDate!);
        // }
        // if (nextPaymentDateTime != null &&
        //     nextPaymentDateTime!.isBefore(DateTime.now())) {
        //   showDialog(
        //       barrierDismissible: false,
        //       context: context,
        //       builder: (context) => Center(
        //             child: Container(
        //               decoration: const BoxDecoration(
        //                   borderRadius: BorderRadius.all(Radius.circular(16))),
        //               height: height * 0.465,
        //               child: WillPopScope(
        //                 onWillPop: () async {
        //                   return false;
        //                 },
        //                 child: const Dialog(
        //                   child: SubscriptionRenewalFail(),
        //                 ),
        //               ),
        //             ),
        //           ));
        // }

        // TODO : Need to remove this check
        if (_checkIfActiveUser || _checkIfNotExpiredAndCanceled) {
          _enableFreshChatForSubscribedUserOnly();
        }
      },
      builder: (context, state) {
        if (isSubscribedBefore != null && !isSubscribedBefore!) {
          // new user to rassel not subscribed before
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      Expanded(
                        child: RasselTrialCardRasselScreenLoggedInUser(
                          originalRasselAmount: originalRasselAmount,
                          currency: currency,
                        ),
                      ),
                      SizedBox(height: height * 0.15)
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        if (hasActiveSubscription != null &&
            isSubscribedBefore != null &&
            hasActiveSubscription! &&
            isSubscribedBefore!) {
          // active user open chat screen
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.08),
              _getRasselBanner(),
              SizedBox(height: height * 0.02),
              _getO7RasselText(),
              SizedBox(height: height * 0.08),
              _getO7RasselAgentCard(),
            ],
          );
        }
        if (hasActiveSubscription != null &&
            isSubscribedBefore != null &&
            userCanceledSubscription != null &&
            !hasActiveSubscription! &&
            isSubscribedBefore! &&
            !userCanceledSubscription!) {
          // renewail fail dialog

          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0.08),
                  _getRasselBanner(),
                  SizedBox(height: height * 0.02),
                  _getO7RasselText(),
                  SizedBox(height: height * 0.08),
                  _getO7RasselAgentCard(),
                ],
              ),
              Container(
                color: ConstColors.textDisabled.withOpacity(0.5),
                height: height,
                width: width,
              ),
              Center(
                child: SizedBox(
                  height: LanguageCubit().state.languageCode == "en"
                      ? height * 0.38
                      : height * 0.348,
                  // height:LanguageCubit().state.languageCode=="en"? 275:255,
                  child: WillPopScope(
                    onWillPop: () async {
                      return false;
                    },
                    child: Dialog(
                      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: SubscriptionRenewalFail(
                          showGoHome: true, subscription: subscription!),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (hasActiveSubscription != null &&
            isSubscribedBefore != null &&
            userCanceledSubscription != null &&
            !hasActiveSubscription! &&
            isSubscribedBefore! &&
            userCanceledSubscription!) {
          if (expirationDate != null &&
              DateTime.parse(expirationDate!).isAfter(DateTime.now())) {
            // open chat screen as user canceled subscription but date not expired
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.08),
                _getRasselBanner(),
                SizedBox(height: height * 0.02),
                _getO7RasselText(),
                SizedBox(height: height * 0.08),
                _getO7RasselAgentCard(),
              ],
            );
          } else {
            // resubscribe as user canceled subscription and date expired
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: [
                        Expanded(
                          child: RasselTrialCardRasselScreenLoggedInUser(
                              originalRasselAmount: originalRasselAmount,
                              currency: currency),
                        ),
                        SizedBox(height: height * 0.15)
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }

  Widget _getO7RasselText() {
    return Wrap(
      children: [
        Text(
          "${translate(LangKeys.o7)} ",
          style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: ConstColors.app),
        ),
        Text(
          translate(LangKeys.rassel),
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: ConstColors.secondary),
        ),
      ],
    );
  }

  Widget _getRasselBanner() {
    return const Center(child: RasselBanner());
  }

  Widget _getO7RasselAgentCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: InkWell(
        onTap: _incrementCounter,
        child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SvgPicture.asset(
                        AssPath.rasselBanner,
                        height: width * 0.12,
                        width: width * 0.1,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        userName == null
                            ? Text(
                                translate(LangKeys.o7RasselAgent),
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: ConstColors.app),
                              )
                            : Text(
                                userName!,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: ConstColors.app),
                              ),
                        SizedBox(
                          width: width / 2,
                          child: ValueListenableBuilder<String?>(
                              valueListenable: notificationMessage,
                              builder: (__, msg, _) {
                                return Text(
                                  msg ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: ConstColors.textSecondary),
                                );
                              }),
                        )
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Text(
                      //   "",
                      //   style: TextStyle(
                      //       fontWeight: FontWeight.w400,
                      //       fontSize: 11,
                      //       color: ConstColors.textSecondary),
                      // ),
                      Container(
                        height: 20,
                        width: 20,
                        decoration: const BoxDecoration(
                          color: ConstColors.accent,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: ValueListenableBuilder<int>(
                            valueListenable: notificationCount,
                            builder: (__, number, _) {
                              return Text(
                                number.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10,
                                    color: ConstColors.app),
                              );
                            },
                          ),
                        ),
                      )
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

  /// active user open chat screen
  bool get _checkIfActiveUser =>
      hasActiveSubscription != null &&
      isSubscribedBefore != null &&
      hasActiveSubscription! &&
      isSubscribedBefore!;

  /// open chat screen as user canceled subscription but date not expired
  bool get _checkIfNotExpiredAndCanceled =>
      (hasActiveSubscription != null &&
          isSubscribedBefore != null &&
          userCanceledSubscription != null &&
          !hasActiveSubscription! &&
          isSubscribedBefore! &&
          userCanceledSubscription!) &&
      (expirationDate != null &&
          DateTime.parse(expirationDate!).isAfter(DateTime.now()));

  /// TODO : Need to move this method to FreshChatHelper
  _getUnreadMessagesCount() {
    log("getUnreadCountAsync");

    /// count when open the screen
    Freshchat.getUnreadCountAsync.then(
      (value) => notificationCount.value = value["count"],
    );

    /// get the count of unread messages
    /// when unreadCountStream update with event true
    _unreadCountStream ??= Freshchat.onMessageCountUpdate;
    _onMessageCountUpdate ??= _unreadCountStream?.listen((event) {
      if (event) {
        Freshchat.getUnreadCountAsync.then((value) {
          notificationCount.value = value["count"];
        });
      }

      log("Have unread messages: $event");
    });
  }
}
