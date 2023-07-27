import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class DidNotReceiveEmailFieldText extends BaseStatelessWidget {
  DidNotReceiveEmailFieldText({super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding:
          EdgeInsets.only(left: 24, right: 24, top: height / 35, bottom: 24),
      child: Center(
        child: Text.rich(
          TextSpan(
              text: translate(LangKeys.didNotReceiveEmailWithoutEdit),
              style: const TextStyle(
                fontSize: 13,
                color: ConstColors.text,
              ),
              children: <TextSpan>[
                // TextSpan(
                //   text: "\t${translate(LangKeys.editEmail)}",
                //   style: const TextStyle(
                //     fontSize: 13,
                //     color: ConstColors.secondary,
                //     decoration: TextDecoration.underline,
                //   ),
                //   recognizer: TapGestureRecognizer()
                //     ..onTap = () => Navigator.of(context).pop(),
                // ),
              ]),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
