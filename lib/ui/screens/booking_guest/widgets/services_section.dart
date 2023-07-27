import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/auth/signup/signup_screen.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

// the title used in services
enum ServicesTitle {
  oneOnOneSessions(translatedText: LangKeys.oneOnOneSessions),
  couplesTherapy(translatedText: LangKeys.couplesTherapy),
  familyCounseling(translatedText: LangKeys.familyCounseling),
  workshops(translatedText: LangKeys.workshops),
  groupTherapy(translatedText: LangKeys.groupTherapy),
  webinars(translatedText: LangKeys.webinars);

  const ServicesTitle({required this.translatedText});

  final String translatedText;
}

/// Services Section of booking screen and  Booking Screen
// ignore: must_be_immutable
class ServicesSection extends BaseStatelessWidget {
  ServicesSection({Key? key}) : super(key: key);

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      children: [
        _getServicesSectionGridView(),
        _getServicesStartNowButton(context),
      ],
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

  /// git the grid view of the services Section
  Widget _getServicesSectionGridView() {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      primary: false,
      shrinkWrap: true,
      // This is the only top padding for all gird >> not just for a single grid
      padding: EdgeInsets.only(
        top: 0.013 * height,
        bottom: 0.02 * height,
      ),
      mainAxisSpacing: 0.013 * height,
      crossAxisSpacing: 0.04 * width,
      crossAxisCount: 2,
      children: List.generate(
        ServicesTitle.values.length,
        (index) => _getSingleServiceBox(index),
      ),
    );
  }

  /// get only Single Service Box
  Widget _getSingleServiceBox(int index) {
    return Container(
      width: width * 0.41,
      height: height * 0.1,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: ConstColors.disabled,
            width: 1.0,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.zero,
          )),
      child: Padding(
        padding: EdgeInsets.only(
          top: 0.02 * height,
          bottom: 0.013 * height,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: ConstColors.disabled,
              // TODO :: wait the image from shymaa
              child: Image.asset(
                AssPath.defaultImg,
                fit: BoxFit.cover,
                scale: 1.5,
              ),
            ),
            Text(
              translate(ServicesTitle.values[index].translatedText),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: ConstColors.app,
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// get Services Start Now button
  Widget _getServicesStartNowButton(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: width * 0.70,
      child: SizedBox(
        width: width,
        height: 45,
        child: ElevatedButton(
          //  when onPressed clicked on it it should navigate to signUp screen
          onPressed: () =>
              Navigator.of(context).pushNamed(SignupScreen.routeName),

          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ))),
          child: Text(translate(LangKeys.startNow)),
        ),
      ),
    );
  }
}
