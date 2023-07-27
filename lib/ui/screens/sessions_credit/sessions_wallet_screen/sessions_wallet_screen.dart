import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/booking/booking_screen/booking_screen.dart';
import 'package:o7therapy/ui/screens/home/home_main_logged_in/home_main_logged_in/home_main_logged_in_screen.dart';
import 'package:o7therapy/ui/screens/sessions_credit/bloc/sessions_credit_bloc.dart';
import 'package:o7therapy/ui/screens/sessions_credit/widgets/sessions_wallet_card.dart';
import 'package:o7therapy/ui/widgets/app_bar_more_screens/app_bar_more_screens.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';

class SessionsWalletScreen extends BaseScreenWidget {
  static const routeName = '/sessions-wallet-screen';

  const SessionsWalletScreen({Key? key}) : super(key: key);

  @override
  BaseState<BaseStatefulWidget> screenCreateState() {
    return _SessionsWalletScreenState();
  }
}

class _SessionsWalletScreenState extends BaseScreenState<SessionsWalletScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SessionsCreditBloc>().add(SessionsWalletLoading());
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBarForMoreScreens(
        title: translate(LangKeys.sessionsWallet),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: _getBody(),
      ),
    ));
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

  Widget _getBody() {
    return BlocConsumer<SessionsCreditBloc, SessionsCreditState>(
      listener: (context, state) {
        if (state is SessionsWalletLoadingState) {
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
      },
      builder: (context, state) {
        if (state is SessionsCreditSuccess) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  translate(LangKeys.useTheCreditInYourSessionsWallet),
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: ConstColors.text,
                  ),
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  primary: false,
                  itemCount: state.sessionsWalletList.data!.list!.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: height / 4,
                      child: SessionsWalletCard(
                          sessionsList:
                              state.sessionsWalletList.data!.list![index]),
                    );
                  }),
            ],
          );
        } else {
          return _getEmptyScreen();
        }
      },
    );
  }

  //Empty Screen components
  //Empty screen
  Widget _getEmptyScreen() {
    return Column(children: [
      _getHeaderBannerSection(),
      _getNoPaymentMethodYetSection(),
      Padding(
          padding: EdgeInsets.only(
              top: height / 20, left: width / 10, right: width / 10),
          child: _getButton(
              buttonText: translate(LangKeys.bookASession),
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              buttonColor: ConstColors.app,
              textColor: ConstColors.appWhite,
              onPressed: () {
                /// this will navigate the user to home main that contains app bar and bottom bar
                /// but with index 1 === is the booking screen
                Navigator.of(context).pushNamedAndRemoveUntil(
                  HomeMainLoggedInScreen.routeName,
                  (route) => false,
                  arguments: HomeMainLoggedInPages.bookingScreen,
                );
              }))
    ]);
  }

  //Header banner section
  Widget _getHeaderBannerSection() {
    return Center(
        child: Padding(
            padding: EdgeInsets.only(top: height / 7),
            child: CircleAvatar(
                foregroundImage: const AssetImage(AssPath.activityBanner),
                backgroundColor: ConstColors.appWhite,
                radius: width / 4)));
  }

  //No payment methods yet text section
  Widget _getNoPaymentMethodYetSection() {
    return Padding(
        padding: EdgeInsets.only(
            top: height / 20, left: width / 10, right: width / 10),
        child: Center(
            child: Text(translate(LangKeys.noCreditInYourSessionsWallet),
                style: const TextStyle(
                    color: ConstColors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center)));
  }

  //Get Elevated button
  Widget _getButton(
      {required String buttonText,
      required double fontSize,
      required FontWeight fontWeight,
      required Color buttonColor,
      required Color textColor,
      required Function() onPressed}) {
    return Container(
        alignment: Alignment.center,
        width: width / 1.5,
        child: SizedBox(
            width: width,
            height: 45,
            child: ElevatedButton(
                onPressed: onPressed,
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(buttonColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)))),
                child: Text(buttonText,
                    style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                        color: textColor)))));
  }
}
