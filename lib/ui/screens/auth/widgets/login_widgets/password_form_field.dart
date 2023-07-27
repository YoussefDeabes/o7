import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class PasswordFormField extends StatefulWidget {
  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;

  const PasswordFormField({
    Key? key,
    required this.passwordController,
    required this.passwordFocusNode,
  }) : super(key: key);

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    String Function(String) translate = AppLocalizations.of(context).translate;
    return TextFormField(
      obscureText: obscure,
      autocorrect: false,
      controller: widget.passwordController,
      focusNode: widget.passwordFocusNode,
      textInputAction: TextInputAction.done,
      onChanged: (String? value) {
        AuthBloc.bloc(context).add(ValidatePasswordEvent(value ?? ""));
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        isDense: true,
        // alignLabelWithHint: true,
        label: Text(
          translate(LangKeys.password),
          style: const TextStyle(
              color: ConstColors.text,
              fontWeight: FontWeight.w400,
              fontSize: 14),
        ),
        errorStyle: const TextStyle(color: ConstColors.error),
        // suffixIconConstraints: const BoxConstraints.tightFor(height: 16),
        suffixIcon: IconButton(
          iconSize: 25,
          // Based on passwordVisible state choose the icon
          icon: obscure
              ? SvgPicture.asset(AssPath.hideEyeIcon)
              : SvgPicture.asset(AssPath.showEyeIcon),

          color: ConstColors.authSecondary,

          onPressed: () {
            // Update the state i.e.
            // toggle the state of passwordVisible variable
            setState(() {
              obscure = !obscure;
            });
          },
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return translate(LangKeys.passwordEmptyErr);
        } else {
          return null;
        }
      },
    );
  }
}
