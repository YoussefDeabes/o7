import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/auth/signup/signup_screen.dart';
import 'package:o7therapy/ui/screens/get_started/get_started_screen.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class SchedulePageGuestTherapistProfile extends BaseStatelessWidget {
  SchedulePageGuestTherapistProfile({
    super.key,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return Container(
      color: ConstColors.appWhite,
      constraints: const BoxConstraints(maxHeight: 50, minHeight: 50),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            translate(LangKeys.createYourAccountToBookNow),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: ConstColors.app,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            width: width * 0.7,
            height: 45,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  SignupScreen.routeName,
                  (route) => route.settings.name == GetStartedScreen.routeName,
                );
              },
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  )),
              child: Text(translate(LangKeys.signUp)),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                translate(LangKeys.alreadyHaveAProfile),
                style: const TextStyle(
                    color: ConstColors.text,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    LoginScreen.routeName,
                    (route) =>
                        route.settings.name == GetStartedScreen.routeName,
                  );
                },
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    alignment: Alignment.centerLeft),
                child: Text(
                  translate(LangKeys.login),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                    color: ConstColors.txtButton,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
