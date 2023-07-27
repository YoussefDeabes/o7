import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/validator.dart';

class EmailFormField extends StatelessWidget {
  final FocusNode emailFocusNode;
  final TextEditingController emailController;
  final FocusNode passwordFocusNode;
  const EmailFormField({
    Key? key,
    required this.emailFocusNode,
    required this.emailController,
    required this.passwordFocusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String Function(String) translate = AppLocalizations.of(context).translate;
    return TextFormField(
      autocorrect: false,

// With precentage only 50%   -- tidebe5619@submic.com
// With precentage only 100%    --   titajes739@spruzme.com
// without range - all therapist       gemy2@cor.co     --   mony@cor.co
// with range display all therapist    Hany@unique.edu
// with range and display only in range    hady@aqua.org
// USD Client  Kamal@flatco.com
// with flat rate   Zaina@flatco.com

      // controller: isDebugMode()
      //     ? TextEditingController(text: "testvpn@gmail.com")
      //     : null,
      //
      // controller: isDebugMode()
      //     ? TextEditingController(text: "zain@flatco.com")
      //     : null,
      // controller: isDebugMode()
      //     ? TextEditingController(text: "cefelis767@runqx.com")
      //     : null,
      // controller: isDebugMode()
      //     ? TextEditingController(text: "Zaina@flatco.com")
      //     : null,
      // controller:
      //     isDebugMode() ? TextEditingController(text: emailTxt) : null,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      obscureText: false,
      focusNode: emailFocusNode,
      textInputAction: TextInputAction.next,
      onChanged: (String value) {
        AuthBloc.bloc(context).add(ValidateEmailEvent(value));
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        alignLabelWithHint: true,
        label: Text(
          translate(LangKeys.email),
          style: const TextStyle(
            color: ConstColors.text,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
        errorStyle: const TextStyle(color: ConstColors.error),
      ),
      onSaved: (String? value) {
        FocusScope.of(context).requestFocus(passwordFocusNode);
      },
      validator: (value) {
        if (value!.isEmpty) {
          return translate(LangKeys.emailEmptyErr);
        } else if (!Validator.isEmail(value)) {
          return translate(LangKeys.invalidEmail);
        } else {
          return null;
        }
      },
    );
  }
}
