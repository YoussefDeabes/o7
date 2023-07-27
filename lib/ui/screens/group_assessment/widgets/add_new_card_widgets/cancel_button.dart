import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Chip(
        backgroundColor: ConstColors.appWhite,
        side: const BorderSide(color: ConstColors.app),
        label: Text(
          AppLocalizations.of(context).translate(LangKeys.cancel),
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: ConstColors.app,
          ),
        ),
      ),
    );
  }
}
