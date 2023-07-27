import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/auth/signup/signup_screen.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

/// Not registered yet row
/// Joined before row for login route
class NotRegisteredRow extends StatelessWidget {
  const NotRegisteredRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context).translate(LangKeys.notRegistered),
          style: const TextStyle(
              color: ConstColors.text, fontWeight: FontWeight.w500),
        ),
        const SignUpButton(),
      ],
    );
  }
}

/// Sign up button
class SignUpButton extends StatelessWidget {
  const SignUpButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).pushNamed(SignupScreen.routeName),
      child: Text(
        AppLocalizations.of(context).translate(LangKeys.signUp),
        style: const TextStyle(
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.underline,
            color: ConstColors.txtButton),
      ),
    );
  }
}
