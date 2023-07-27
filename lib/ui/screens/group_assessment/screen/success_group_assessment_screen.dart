import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/checkout/bloc/checkout_bloc.dart';
import 'package:o7therapy/ui/screens/home/home_main_logged_in/home_main_logged_in/home_main_logged_in_screen.dart';
import 'package:o7therapy/ui/widgets/success_header_image.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class SuccessGroupAssessmentScreen extends BaseScreenWidget {
  static const routeName = '/success-group-assessment-screen';

  const SuccessGroupAssessmentScreen({Key? key}) : super(key: key);

  @override
  BaseState<SuccessGroupAssessmentScreen> screenCreateState() =>
      _SuccessGroupAssessmentScreenState();
}

class _SuccessGroupAssessmentScreenState
    extends BaseScreenState<SuccessGroupAssessmentScreen> {
  final GlobalKey webViewKey = GlobalKey();
  String therapistName = "";
  String sessionDate = "";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      therapistName = args['therapistName'] as String;
      sessionDate = args['sessionDate'] as String;
    });
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _getBody(),
        // body: _inappWeb(),
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
              SuccessHeaderImage(),
              _getDetailsCard(),
              _doneButton(),
            ],
          ),
        );
      },
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
                              text:
                                  "${translate(LangKeys.yourSessionWith)} $therapistName ",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: ConstColors.text)),
                          TextSpan(
                              text: "${translate(LangKeys.day)} ",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: ConstColors.text)),
                          TextSpan(
                            text:
                                "${(sessionDate.isNotEmpty ? DateFormat('EEEE MMM dd, yyyy').format(_getDate(sessionDate)) : "")} ",
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: ConstColors.text),
                          ),
                          TextSpan(
                              text: "${translate(LangKeys.theHour)} ",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: ConstColors.text)),
                          TextSpan(
                            text:
                                "${sessionDate.isNotEmpty ? DateFormat().add_jm().format(_getDate(sessionDate)) : ""} ",
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: ConstColors.text),
                          ),
                          TextSpan(
                              text: translate(LangKeys.isConfirmed),
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
  Widget _doneButton() {
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
              (Route<dynamic> route) => false,
            );
          },
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ))),
          child: Text(translate(LangKeys.home)),
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
