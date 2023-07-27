import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

///  Clear Button For gender selection and language
class ClearButton extends StatelessWidget {
  final void Function()? onPressed;
  const ClearButton({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        AppLocalizations.of(context).translate(LangKeys.clear),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.underline,
          color: ConstColors.textDisabled,
        ),
      ),
    );
  }
}
