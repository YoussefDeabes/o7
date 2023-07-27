import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/checkout/bloc/checkout_bloc.dart';
import 'package:o7therapy/ui/screens/home/home_main_logged_in/home_main_logged_in/home_main_logged_in_screen.dart';
import 'package:o7therapy/ui/screens/sessions_credit/bloc/sessions_credit_bloc.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class SuccessRasselSubscriptionScreen extends BaseScreenWidget {
  static const routeName = '/success-rassel-screen';

  const SuccessRasselSubscriptionScreen({Key? key}) : super(key: key);

  @override
  BaseState<SuccessRasselSubscriptionScreen> screenCreateState() =>
      _SuccessRasselSubscriptionScreenState();
}

class _SuccessRasselSubscriptionScreenState
    extends BaseScreenState<SuccessRasselSubscriptionScreen> {
  final GlobalKey webViewKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    context.read<CheckoutBloc>().add(SuccessPaymentScreenEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // context.read<CheckoutBloc>().add(SuccessPaymentScreenEvent());
    Future.delayed(Duration.zero).then((_) {
      // context.read<CheckoutBloc>().add(SuccessPaymentScreenEvent());
    });
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<SessionsCreditBloc>().add(SessionsWalletLoading());
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: _getBody(),
          // body: _inappWeb(),
        ),
      ),
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

  Widget _getBody() {
    return BlocConsumer<CheckoutBloc, CheckoutState>(
      listener: (context, state) {
        if (state is CheckoutLoadingState) {
          showLoading();
        } else {
          hideLoading();
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _headerImage(),
              _getDetailsCard(),
              _startNowButton(),
            ],
          ),
        );
      },
    );
  }

  //Header Image
  Widget _headerImage() {
    return Padding(
      padding: EdgeInsets.only(top: height / 15),
      child: CircleAvatar(
        foregroundImage: const AssetImage(AssPath.success),
        backgroundColor: ConstColors.scaffoldBackground,
        maxRadius: width * 0.35,
      ),
    );
  }

  //Details card
  Widget _getDetailsCard() {
    return Padding(
      padding: EdgeInsets.only(top: height / 30),
      child: SizedBox(
        width: width,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _getPatientName(),
                SizedBox(
                  width: width / 1.5,
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                            fontSize: 14, color: ConstColors.text),
                        children: <TextSpan>[
                          TextSpan(
                              text: translate(
                                  LangKeys.youHaveSuccessfullySubscribedTo),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: ConstColors.text)),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getPatientName() {
    return FutureBuilder<String?>(
      future: PrefManager.getName(),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.hasData) {
          return Text(
            '${translate(LangKeys.hey)} ${snapshot.data ?? ""}',
            style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: ConstColors.app),
            textAlign: TextAlign.center,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  //Pay now button
  Widget _startNowButton() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 25.0, left: width / 10, right: width / 10),
      child: SizedBox(
        width: width,
        height: 45,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              HomeMainLoggedInScreen.routeName,
              arguments: HomeMainLoggedInPages.rasselScreen,
              (Route<dynamic> route) => false,
            );
          },
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ))),
          child: Text(translate(LangKeys.startNowRassel)),
        ),
      ),
    );
  }

///////////////////////////////////////////////////////////
/////////////////// Helper methods ////////////////////////
///////////////////////////////////////////////////////////
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
}
