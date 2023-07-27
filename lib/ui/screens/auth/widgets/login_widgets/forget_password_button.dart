import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/auth/forget_password/forget_password_screen.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

/// Forget password button for login screen
class ForgetPasswordButton extends StatelessWidget {
  const ForgetPasswordButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(ForgetPasswordScreen.routeName);
          },
          child: Text(
            AppLocalizations.of(context).translate(LangKeys.forgetPassword),
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
                color: ConstColors.secondary),
          ),
        ),
      ],
    );
  }
}
