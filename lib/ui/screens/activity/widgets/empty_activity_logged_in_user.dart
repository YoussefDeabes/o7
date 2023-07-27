import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/home/home_main_logged_in/home_main_logged_in/home_main_logged_in_screen.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/footer_widget.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class EmptyActivityLoggedInUser extends BaseStatelessWidget {
  EmptyActivityLoggedInUser({super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _getHeaderBannerSection(),
            _getNoActivityYetSection(),
            _getStartNowButton(context),
            const FooterWidget(),
          ],
        ),
      ),
    );
  }

  //Header banner section
  Widget _getHeaderBannerSection() {
    return Center(
      child: CircleAvatar(
        // backgroundImage: const AssetImage(AssPath.activityBanner),
        foregroundImage: const AssetImage(AssPath.activityBanner),
        // child: SvgPicture.asset(AssPath.activityBanner,fit: BoxFit.cover,),
        backgroundColor: ConstColors.appWhite,
        // backgroundImage: AssetImage(AssPath.defaultImg,),
        radius: width / 4,
      ),
    );
  }

  //No activity yet text section
  Widget _getNoActivityYetSection() {
    return Padding(
      padding: EdgeInsets.only(
          top: height / 20, left: width / 10, right: width / 10),
      child: Text(
        translate(LangKeys.noActivityYet),
        style: const TextStyle(
            color: ConstColors.text, fontSize: 16, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );
  }

  //Start now button
  Widget _getStartNowButton(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(
          top: height / 20, left: width / 10, right: width / 10),
      child: SizedBox(
        width: width,
        height: 45,
        child: ElevatedButton(
          onPressed: () {
            /// this will navigate the user to home main that contains app bar and bottom bar
            /// but with index 1 === is the booking screen
            Navigator.of(context).pushReplacementNamed(
              HomeMainLoggedInScreen.routeName,
              arguments: HomeMainLoggedInPages.bookingScreen,
            );
          },
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ))),
          child: Text(translate(LangKeys.bookASession)),
        ),
      ),
    );
  }
}
