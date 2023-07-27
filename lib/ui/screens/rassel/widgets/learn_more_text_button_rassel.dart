import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/rassel/widgets/rassel_service_info_bottom_sheet.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class LearnMoreTextButtonRassel extends BaseStatelessWidget
    with RasselServiceInfoBottomSheet {
  LearnMoreTextButtonRassel({super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () => rasselServiceInfoBottomSheet(context, translate),
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Text(
            translate(LangKeys.learnMoreTextButtonRassel),
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: ConstColors.secondary,
                decoration: TextDecoration.underline),
          ),
        ),
      ),
    );
  }
}
