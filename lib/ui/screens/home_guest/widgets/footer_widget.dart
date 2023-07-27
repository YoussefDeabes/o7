import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 39.0, bottom: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset(
              AssPath.lockIcon,
              // scale: 2.5,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 13.0, bottom: 7),
              child: Text(
                context.translate(LangKeys.yourInfoIsYours),
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: ConstColors.app),
              ),
            ),
            Text(
              context.translate(LangKeys.encryptedHIPPA),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: ConstColors.text,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
