import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/my-subscriptions/widgets/my_subscription_card.dart';
import 'package:o7therapy/ui/screens/my-subscriptions/widgets/no_subscriptions.dart';
import 'package:o7therapy/ui/screens/rassel/bloc/rassel_bloc/rassel_bloc.dart';
import 'package:o7therapy/ui/widgets/app_bar_more_screens/app_bar_more_screens.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../../../_base/widgets/base_screen_widget.dart';
import '../../../../res/const_colors.dart';
import '../../../../util/lang/app_localization_keys.dart';
import '../../profile/bloc/profile_bloc.dart';

class MySubscriptionScreen extends BaseScreenWidget {
  static const routeName = '/my-subscriptions-screen';

  const MySubscriptionScreen({Key? key}) : super(key: key);

  @override
  BaseScreenState<MySubscriptionScreen> screenCreateState() =>
      _MySubscriptionScreenState();
}

class _MySubscriptionScreenState extends BaseScreenState<MySubscriptionScreen> {
  bool noSubscription = false;
  bool isActive = true;
  int tabIndex = 0;

  @override
  void initState() {
    context.read<RasselBloc>().add(RasselClientSubscriptionsEvt());
    super.initState();
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBarForMoreScreens(title: translate(LangKeys.mySubscriptions)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            BlocConsumer<RasselBloc, RasselState>(listener: (context, state) {
          if (state is RasselLoadingState) {
            showLoading();
          } else {
            hideLoading();
          }
          if (state is RasselCancelSubscriptionState) {
            context.read<RasselBloc>().add(RasselClientSubscriptionsEvt());
            Navigator.of(context).pop();
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
          if (state is RasselClientSubscriptionState) {
            if (state.rasselClientSubscriptions == null) {
              noSubscription = true;
            }
          }
        }, builder: (context, state) {
          if (state is RasselClientSubscriptionState &&
              noSubscription == false) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ToggleSwitch(
                    initialLabelIndex: tabIndex,
                    textDirectionRTL: true,
                    totalSwitches: 2,
                    cornerRadius: 30.0,
                    minWidth: width / 2,
                    inactiveBgColor: ConstColors.appWhite,
                    inactiveFgColor: ConstColors.textSecondary,
                    activeFgColor: ConstColors.appWhite,
                    radiusStyle: true,
                    borderWidth: 1,
                    labels: [
                      translate(LangKeys.activeSubscription),
                      translate(LangKeys.inActiveSubscription)
                    ],
                    onToggle: (index) {
                      toggleSwitch(index!);
                    },
                  ),
                ),
                // (state
                //     .rasselClientSubscriptions
                //     .data!.where((element) => element.isActive==isActive).isEmpty)?
                // (state.rasselClientSubscriptions!.data?.isActive ==
                //             isActive &&
                //         DateTime.parse(state.rasselClientSubscriptions!
                //                 .data!.nextPaymentDate!)
                //             .isAfter(DateTime.now()))
                (state.rasselClientSubscriptions!.data?.isActive != isActive)
                    ? const Expanded(child: NoSubscriptionsWidget())
                    : SizedBox(
                        child: MySubscriptionsCard(
                          subscriptions: state.rasselClientSubscriptions!.data!,
                          // subscriptions: state
                          //     .rasselClientSubscriptions
                          //     .data!.where((element) => element.isActive==isActive).elementAt(index)),
                          // child: ListView.builder(
                          //     itemCount: state
                          //         .rasselClientSubscriptions
                          //         .data!.where((element) => element.isActive==isActive).length,
                          //     itemBuilder: (context, index) => SizedBox(
                          //         height: height * .27,
                          //         child: MySubscriptionsCard(
                          //             subscriptions: state
                          //                 .rasselClientSubscriptions
                          //                 .data!.where((element) => element.isActive==isActive).elementAt(index)))),
                        ),
                      ),
              ],
            );
          } else if (state is RasselClientSubscriptionState && noSubscription) {
            return const NoSubscriptionsWidget();
          } else {
            return const NoSubscriptionsWidget();
          }
        }),
      ),
    ));
  }

  void toggleSwitch(int index) {
    tabIndex = index;
    if (index == 0) {
      setState(() {
        tabIndex = index;
        isActive = true;
      });
    } else if (index == 1) {
      setState(() {
        tabIndex = index;
        isActive = false;
      });
    }
  }
}
