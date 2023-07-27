import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/ui/screens/auth/widgets/two_colored_header_text.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class ResetPasswordTwoColoredHeaderText extends BaseStatelessWidget {
  ResetPasswordTwoColoredHeaderText({Key? key}) : super(key: key);

  @override
  Widget baseBuild(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TwoColoredHeaderText(
          firstColoredText: "${translate(LangKeys.resetForPassWord)} ",
          secondColoredText: translate(LangKeys.yourPassword)),
    );
  }
}
