import 'package:flutter/material.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/widgets/card_widgets/svg_card_icon.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class TherapistYearsOfExperience extends StatelessWidget {
  final int? yearsOfExperience;
  const TherapistYearsOfExperience({
    super.key,
    required this.yearsOfExperience,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SvgCardIcon(assetPath: AssPath.caseIcon),
        // SvgPicture.asset(AssPath.caseIcon),
        // Image.asset(AssPath.caseIcon, width: 0.04 * width),
        SizedBox(width: 0.016 * MediaQuery.of(context).size.width),
        RichText(
            text: TextSpan(
          style: const TextStyle(
              fontSize: 13.0,
              color: ConstColors.text,
              fontWeight: FontWeight.w600),
          children: [
            TextSpan(
              text: '$yearsOfExperience ',
            ),
            TextSpan(
              text: AppLocalizations.of(context).translate(LangKeys.yr),
            ),
          ],
        )),
      ],
    );
  }
}
