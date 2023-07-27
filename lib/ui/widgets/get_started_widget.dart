import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/auth/signup/signup_screen.dart';
import 'package:o7therapy/ui/screens/profile/widgets/custom_rounded_button.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class GetStartedWidget extends BaseStatelessWidget {
  GetStartedWidget({Key? key}) : super(key: key);

  @override
  Widget baseBuild(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: height * 0.26,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            translate(LangKeys.createAccountToStart),
            style:const TextStyle(fontWeight: FontWeight.w600, fontSize: 16,color: ConstColors.app),
            textAlign: TextAlign.center,
          ),
          const  SizedBox(
            height: 16,
          ),
          CustomRoundedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(SignupScreen.routeName);

              },
              text: translate(LangKeys.signUp),
              widthValue: width * 0.7),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(translate(LangKeys.alreadyHaveAProfile),style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 14),),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(LoginScreen.routeName);
                },
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    alignment: Alignment.centerLeft),
                child: Text(
                  translate(LangKeys.login),
                  style: const TextStyle(
                      decoration: TextDecoration.underline,
                      color: ConstColors.txtButton,fontWeight: FontWeight.w500,fontSize: 14),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
