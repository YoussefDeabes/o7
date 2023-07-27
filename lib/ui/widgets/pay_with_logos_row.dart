import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class payWithLogosRow extends BaseStatelessWidget {
  payWithLogosRow({super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              translate(LangKeys.payWith),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: ConstColors.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SvgPicture.asset(
                AssPath.visaLogo,
                height: 10,
                width: 10,
                // scale: 2.5,
              ),
            ),
            Image.asset(
              AssPath.mastercardLogo,
              scale: 40,
            ),
          ],
        ),
        Image.asset(
          AssPath.payfortLogo,
          scale: 3,
        )
      ],
    );
  }
}
