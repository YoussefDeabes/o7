import 'package:flutter/material.dart';
import 'package:o7therapy/ui/screens/home/home_main_logged_in/home_main_logged_in/home_main_logged_in_screen.dart';
import 'package:o7therapy/ui/screens/profile/widgets/custom_rounded_button.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class BookASessionButtonInHomeLoggedIn extends StatelessWidget {
  const BookASessionButtonInHomeLoggedIn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomRoundedButton(
      fontsize: 14,
      onPressed: () {
        /// this will navigate the user to home main that contains app bar and bottom bar
        /// but with index 1 === is the booking screen
        Navigator.of(context).pushNamedAndRemoveUntil(
          HomeMainLoggedInScreen.routeName,
          (route) => false,
          arguments: HomeMainLoggedInPages.bookingScreen,
        );
      },
      text: context.translate(LangKeys.bookASession),
      widthValue: context.width * 0.64,
    );
  }
}
