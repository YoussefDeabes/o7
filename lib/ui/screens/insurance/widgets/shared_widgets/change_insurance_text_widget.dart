import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class ChangeInsuranceTextWidget extends BaseStatelessWidget {
  ChangeInsuranceTextWidget({super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return Center(
      child: Text(
        translate(LangKeys.changeInsurance),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: ConstColors.app,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
