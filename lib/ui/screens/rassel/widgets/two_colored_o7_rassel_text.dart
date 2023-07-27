import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class TwoColoredO7RasselText extends StatelessWidget {
  const TwoColoredO7RasselText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        TextSpan(
          children: [
            TextSpan(text: '${context.translate(LangKeys.o7)} '),
            TextSpan(
              text: context.translate(LangKeys.rassel),
              style: const TextStyle(color: ConstColors.secondary),
            ),
          ],
        ),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: ConstColors.app,
        ),
      ),
    );
  }
}
