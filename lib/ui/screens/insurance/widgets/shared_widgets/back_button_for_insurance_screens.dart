import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/insurance/widgets/shared_widgets/shared_widgets.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

/// Get Back button to back to previous page
class BackButtonForInsuranceScreen extends BaseStatelessWidget {
  BackButtonForInsuranceScreen({super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return InsurancePageButton(
      buttonColor: ConstColors.appWhite,
      fontColor: ConstColors.app,
      width: width * 0.3,
      onPressed: () => Navigator.pop(context),
      buttonLabel: translate(LangKeys.back),
    );
  }
}
