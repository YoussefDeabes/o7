import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

/// get the therapist job title
/// Psychiatrist prescribe medication,
/// psychologist can't.
class TherapistJobTitle extends StatelessWidget {
  final bool? canPrescribe;
  const TherapistJobTitle({super.key, required this.canPrescribe});

  @override
  Widget build(BuildContext context) {
    return Text(
      canPrescribe == null
          ? ""
          : AppLocalizations.of(context).translate(
              canPrescribe! ? LangKeys.psychiatrist : LangKeys.psychologist,
            ),
      textAlign: TextAlign.start,
      maxLines: 1,
      style: const TextStyle(
          color: ConstColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w400),
    );
  }
}
