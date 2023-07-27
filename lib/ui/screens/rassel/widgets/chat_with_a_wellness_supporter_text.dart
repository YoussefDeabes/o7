import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class ChatWithAWellnessSupporterText extends BaseStatelessWidget {
  ChatWithAWellnessSupporterText({super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Text(
          translate(LangKeys.chatWithAWellnessSupporter),
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: ConstColors.text),
        ),
      ),
    );
  }
}
