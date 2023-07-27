import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/home/home_main_logged_in/home_main_logged_in/home_main_logged_in_screen.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class EmptyContactsTherapistsMessagesListPage extends BaseStatelessWidget {
  EmptyContactsTherapistsMessagesListPage({super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            foregroundImage: const AssetImage(AssPath.activityBanner),
            backgroundColor: ConstColors.appWhite,
            radius: width / 3,
          ),
          SizedBox(height: 0.03 * height),
          SizedBox(
            width: width * 0.7,
            child: Text(
              translate(LangKeys.noMessagesAvailable),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: ConstColors.text,
              ),
            ),
          ),
          SizedBox(height: 0.1 * height),
          _getBookASessionButton(context),
        ],
      ),
    );
  }

  /// Get Book A Session button
  Widget _getBookASessionButton(BuildContext context) {
    return SizedBox(
        width: width * 0.7,
        height: 45,
        child: ElevatedButton(
          onPressed: () {
            /// this will navigate the user to home main that contains app bar and bottom bar
            /// but with index 1 === is the booking screen
            Navigator.of(context).pushNamedAndRemoveUntil(
              HomeMainLoggedInScreen.routeName,
              (route) => false,
              arguments: HomeMainLoggedInPages.bookingScreen,
            );
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: ConstColors.app,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              )),
          child: Text(
            translate(LangKeys.bookASession),
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: ConstColors.appWhite,
            ),
          ),
        ));
  }
}
