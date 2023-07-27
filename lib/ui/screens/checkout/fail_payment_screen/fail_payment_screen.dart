import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/home/home_main_logged_in/home_main_logged_in/home_main_logged_in_screen.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class FailPaymentScreen extends BaseScreenWidget {
  static const routeName = '/fail-payment-screen';

  const FailPaymentScreen({Key? key}) : super(key: key);

  @override
  BaseState<FailPaymentScreen> screenCreateState() => _FailPaymentScreenState();
}

class _FailPaymentScreenState extends BaseScreenState<FailPaymentScreen> {
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
          _headerImage(),
          _getDetailsCard(),
          // _tryAgainButton(),
          _cancelButton()
        ],
      ),
    );
  }

  //Header Image
  Widget _headerImage() {
    return Padding(
      padding: EdgeInsets.only(top: height / 15),
      child: CircleAvatar(
        foregroundImage: AssetImage(AssPath.fail),
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
