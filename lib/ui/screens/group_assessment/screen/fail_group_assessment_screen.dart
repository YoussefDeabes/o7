import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';

import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/home/home_main_logged_in/home_main_logged_in/home_main_logged_in_screen.dart';
import 'package:o7therapy/ui/widgets/fail_header_image.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class FailGroupAssessmentScreen extends BaseScreenWidget {
  static const routeName = '/fail-group-assessment-screen';

  const FailGroupAssessmentScreen({Key? key}) : super(key: key);

  @override
  BaseState<FailGroupAssessmentScreen> screenCreateState() =>
      _FailGroupAssessmentScreenState();
}

class _FailGroupAssessmentScreenState
    extends BaseScreenState<FailGroupAssessmentScreen> {
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
      ),
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

  Widget _getBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FailHeaderImage(),
          _getDetailsCard(),
          // _tryAgainButton(),
          _cancelButton()
        ],
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
                Text(
                  translate(LangKeys.oops),
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: ConstColors.app),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: width / 1.5,
                  child: Text(
                    translate(LangKeys.somethingWentWrong),
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: ConstColors.text),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //try again button
  Widget _tryAgainButton() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 25.0, left: width / 10, right: width / 10),
      child: SizedBox(
        width: width,
        height: 45,
        child: ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ))),
          child: Text(translate(LangKeys.tryAgain)),
        ),
      ),
    );
  }

  //cancel button
  Widget _cancelButton() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 25.0, left: width / 10, right: width / 10),
      child: SizedBox(
        width: width,
        height: 45,
        child: TextButton(
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
          child: Text(
            translate(LangKeys.cancel),
            style: const TextStyle(
                color: ConstColors.text,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
                fontSize: 14),
          ),
        ),
      ),
    );
  }
///////////////////////////////////////////////////////////
/////////////////// Helper methods ////////////////////////
///////////////////////////////////////////////////////////

}
