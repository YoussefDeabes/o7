import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class CanChatTillWidget extends BaseStatelessWidget {
  CanChatTillWidget({super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: height * 0.3,
      child: Column(
        children: [
          const Divider(),
          Text(
            translate(LangKeys.youCanNotSendMessagesToTheTherapist),
            style: const TextStyle(
              color: ConstColors.text,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
