import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/widgets/widgets.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

/// Continue with label
class ContinueWithRow extends StatelessWidget {
  const ContinueWithRow({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        continueWithLineDivider(height: 1, width: width / 8),
        Text(
          AppLocalizations.of(context).translate(LangKeys.continueWith),
          style: const TextStyle(
              color: ConstColors.app,
              fontWeight: FontWeight.w500,
              fontSize: 14),
        ),
        continueWithLineDivider(height: 1, width: width / 8),
      ],
    );
  }
}
