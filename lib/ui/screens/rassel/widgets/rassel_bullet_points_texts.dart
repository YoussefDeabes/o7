import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class RasselBulletPointsTexts extends BaseStatelessWidget {
  static const bulletsKeys = [
    LangKeys.instantAndAnonymousLiveChatSupport,
    LangKeys.providingSelfHelpResources,
    LangKeys.accessTo2MonthlyWebinars,
    LangKeys.discountsOnTherapySessions,
  ];
  RasselBulletPointsTexts({super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: bulletsKeys
          .map((item) => UnorderedListItem(translate(item)))
          .toList(),
    );
  }
}

class UnorderedListItem extends StatelessWidget {
  const UnorderedListItem(this.text, {super.key});
  final String text;
  static const TextStyle _bulletTextStyle = TextStyle(
    color: ConstColors.text,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Text("• $text", style: _bulletTextStyle),
    );
  }
}
