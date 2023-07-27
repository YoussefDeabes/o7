import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class TherapistProfileExperienceRatingRow extends StatelessWidget {
  final int yearsOfExperience;
  const TherapistProfileExperienceRatingRow({
    super.key,
    required this.yearsOfExperience,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _ExperienceRatingColumn(
          assetPath: AssPath.caseIcon,
          title: AppLocalizations.of(context).translate(LangKeys.experience),
          rate: yearsOfExperience.toString(),
          description: AppLocalizations.of(context).translate(LangKeys.years),
        ),
        // _experienceRatingColumn(AssPath.starIcon, translate(LangKeys.rating),
        //     '4.0', '20 ${translate(LangKeys.review)}')
      ],
    );
  }
}

class _ExperienceRatingColumn extends StatelessWidget {
  final String assetPath;
  final String title;
  final String rate;
  final String description;
  const _ExperienceRatingColumn(
      {required this.assetPath,
      required this.title,
      required this.rate,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Padding(
          padding: const EdgeInsets.only(bottom: 3.0),
          child: SvgPicture.asset(
            assetPath,
            // scale: 1.8,
          )),
      Text(title,
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: ConstColors.text)),
      Text(rate,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: ConstColors.app)),
      Text(description,
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: ConstColors.textSecondary))
    ]);
  }
}
